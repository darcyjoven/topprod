# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_upimg.4gl
# Descriptions...: 更新倉庫庫存明細檔
# Date & Author..: 92/05/23 By Pin
# Usage..........: CALL s_upimg(p_rowid,p_type,p_qty2,p_date,p_item,p_stock,
#                               p_locat,p_lot,p_no,p_line,p_unit,p_qty,p_unit2,
#                               p_fac1,p_fac2,p_fac3,p_act,p_proj,m_pri,s_pri,
#                               p_cla,p_ono)
# Input Parameter: p_rowid   img_file之rowid
#                  p_type    欲更新之方式
#                       +1 入庫
#                        0 報廢,倉庫退貨
#                       -1 出庫
#                       2  盤點
#                  p_qty2    庫存數量(庫存單位)
#                  p_date    異動日期
#                  p_item    料件
#                  p_stock   倉庫
#                  p_locat   儲位
#                  p_lot     批號
#                  p_no      單號
#                  p_line    項次
#                  p_unit    單位(採購/生產)
#                  p_qty     收貨數量(採購/生產單位)
#                  p_unit2   單位(庫存)
#                  p_fac1    庫存單位對採購單位換算率
#                  p_fac2    庫存單位對料件庫存單位換算率
#                  p_fac3    庫存單位對料件成本單位換算率
#                  p_act     倉儲會計科目
#                  p_proj    專案號碼
#                  m_pri     發料優先順序
#                  s_pri     銷售優先順序
#                  p_cla     庫存等級           
#                  p_ono     外觀代號           
# Return code....: NONE
# Modify.........: 92/06/02 By David for 報廢
# Modify.........: 97/06/18 By Melody AIM 3.0 產品會議:check最高存量限制(imf04)
# Modify.........: 01/04/04 by plum cl_err('',asf-375,0) -> ('',aim-406,1)
# Modify.........: No:8652 03/11/06 call 'aim-406' 多秀單號+項次訊息
# Modify.........: No.MOD-490056 04/09/02 Carol 應改成 IF p_stock IS NULL THEN LET p_stock= ' ' END IF
# Modify.........: No.MOD-530003 05/03/11 By ching 加入 apmt742,axmt820 
# Modify.........: No.MOD-530037 05/03/21 By ching 加入 asft700,asft730 
# Modify.........: No.MOD-530408 05/08/11 By Rosayu 1.加入axdt203,aemt200,aemt201,aemt202,aimt326,asfp510,asfp520,asft623
# Modify.........: No.MOD-530408 05/08/11 By Rosayu 2.SELECT img_file之後加show錯誤提示訊息
# Modify.........: No.MOD-530408 05/08/11 By Rosayu 3.DELETE img_file之後加show錯誤提示訊息
# Modify.........: No.MOD-530408 05/08/11 By Rosayu 4.若在CASE....END CASE未找到程式代號g_prog,加show 錯誤提示訊息,並且結束程式
# Modify.........: No.MOD-570002 05/08/11 By rosayu 1.加入axdt202
# Modify.........: No.MOD-570005 05/08/11 By Rosayu 1.加入rowid='-3333'的處理
# Modify.........: No.MOD-570005 05/08/11 By Rosayu 2.一開始LET l_flag='X'
# Modify.........: No.MOD-570005 05/08/11 By Rosayu 3.在show 'aim-409'的提示訊息時多加 條件AND p_type <= 0
# Modify.........: No:Bug-580117 05/08/12 By Rosayu 在MOD-530408新增的錯誤訊息'aim-407'和top66的強碰將aim-407改成aim-419
# Modify.........: No.MOD-580191 05/08/21 By pengu 在update img10時先select出img10做計算，計算完後再update img10
# Modify.........: No.FUN-610057 06/01/13 By Carrier add axmt627/axmt628
# Modify.........: No.FUN-5C0114 06/01/19 By kim add asri210/220/230
# Modify.........: No.FUN-610066 06/02/10 By jackie add atmt260/atmt261
# Modify.........: No.FUN-5C0114 06/02/15 By kim add asrt320
# Modify.........: No.FUN-610074 06/02/16 By Tracy
# Modify.........: No.FUN-610056406/02/17 By wujie add atmt242/atmt260/atmt261/atmt252
# Modify.........: NO.TQC-620156 06/03/09 By kim GP3.0庫存不足err_log 延續 FUN-610070 的修改
# Modify.........: No.FUN-630061 06/03/28 By ice add atmt248
# Modify.........: No.FUN-630102 06/04/04 By Sarah add atmt321
# Modify.........: No.FUN-670091 06/08/02 By rainy cl_err=>cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0083 06/12/03 By Nicola 錯誤訊息彙整
# Modify.........: No.FUN-670012 07/02/05 By ching 行業別 add g_prog[1,7]
# Modify.........: No.CHI-710041 07/03/13 By jamie 取消sma882欄位及其判斷
# Modify.........: No.TQC-730022 07/04/02 By rainy 判斷庫存不足新增axmp230
# Modify.........: No.CHI-740011 07/04/13 By jamie 改CHI-710041判斷
# Modify.........: No.FUN-740016 07/05/08 By Nicola 借出管理修改
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.CHI-830025 08/03/19 By kim GP5.1 整合測試修改
# Modify.........: No.MOD-840244 08/04/20 By Nicola 不做批/序號不執行tlfs
# Modify.........: No.MOD-840251 08/04/20 By Nicola 給預設值
# Modify.........: No.MOD-840312 08/04/20 By Pengu INSERT INTO imgs時會出現-6372錯誤訊息
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: NO.FUN-860025 08/06/16 BY yiting 加上銷貨單處理 
# Modify.........: No.CHI-870007 08/07/02 By Nicola 加入asri210,asri220
# Modify.........: No.CHI-870027 08/07/16 By Nicola 重新過單
# Modify.........: No.MOD-870202 08/07/16 By Nicola 補Action 英文
# Modify.........: No.FUN-870131 08/09/16 By Nicola 出貨多倉儲批/序號功能修改
# Modify.........: No.MOD-8A0045 08/10/06 By clover 程式代號少asrt320，造成asrt320過帳還原錯誤
# Modify.........: No.FUN-8A0147 08/12/11 By douzh  批序號-盤點調整-更新imgs_file從pias_file中資料更新另寫在aimp880里
# Modify.........: No.MOD-8C0132 08/12/15 By claire 新增img_file時,img37呆滯日期以p_date(異動日,扣帳日)為主
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 rowid 
# Modify.........: No.MOD-910104 09/01/09 By claire 報廢單處理同發料單
# Modify.........: No.MOD-910150 09/01/14 By Smapmin 銷退單扣帳還原時沒有update imgs_file
# Modify.........: No.MOD-920321 09/02/25 By Smapmin 批序號不允許負庫存.
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun img_file 增加字段img38/INSERT寫法調整
# Modify.........: No.MOD-940312 09/04/23 By Smapmin 抓取庫存量時,要用SUM(img10*img21)
# Modify.........: No.MOD-960279 09/06/23 By Dido axmt840 比照 axmt700 運用 rvbs09
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun GP5.2 img_file/imgs_file增加字段
# Modify.........: No.FUN-960071 09/07/14 By chenmoyan axmp201庫存不足是否允許出貨扣帳
# Modify.........: No.FUN-TQC-9A0109 09/10/23 By sunyanchun   post to area 32
# Modify.........: No:MOD-9A0172 09/11/03 By Smapmin判斷若是出貨簽收的"簽收在途倉",
#                                                   因為l_ogc18的值不存在,且沒有rvbs_file的資料,
#                                                   所以要抓取原出貨單的rvbs_file資料,故將rvbs13的條件拿掉
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-960130 09/11/08 By Sunyanchun -add artt256
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No.FUN-9B0113 09/11/19 By alex 將$TEMPDIR調為使用FGL_GETENV
# Modify.........: No.FUN-A10037 10/01/08 By bnlent 負庫存出貨添加art作業清單 
# Modify.........: No:MOD-A20117 10/03/02 By Smapmin 多單位多倉儲批時,update imgs_file的動作在各支程式做
# Modify.........: No:FUN-A20048 10/03/31 by liuxqa 出库时，须检查有无备置资料，库存考虑变为库存-备置.
# Modify.........: No:FUN-A80106 10/08/20 by Summer aimt306增加_icd行業 
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.MOD-AA0086 10/10/15 By Carrier aimt325/aimt326 批序号时,WIP仓不能做批序号的内容
# Modify.........: No.FUN-AB0011 10/11/11 By huangtao mod 參數
# Modify.........: No.FUN-AB0055 10/11/25 By jan 判斷當庫存0時，自動壓失效日(bmd06)
# Modify.........: No:MOD-A90100 10/12/10 By Smapmin add add apmt740/apmt742
# Modify.........: No:TQC-AC0298 10/12/20 By jan 工單未備置量應扣除本次發料量
# Modify.........: No:CHI-AC0034 11/01/06 By Summer 調整替代入在途倉時rvbs條件
# Modify.........: No:TQC-B10143 11/01/14 By jan 修正工單備置時的問題
# Modify.........: No:MOD-B10120 11/01/17 By sabrina 若ima918或ima921抓不到資料時提示無此料號或料號無效的訊息
# Modify.........: No:MOD-B30020 11/03/04 By Summer s_upimg_imgs()增加多角的部份:axmt820,axmt821
# Modify.........: No:FUN-B30012 11/03/22 By baogc 新增換贈部份:artt603,artt604
# Modify.........: No:FUN-AC0074 11/04/11 By lixh1 儲批如果沒打但倉庫有打,就只備置到倉,倉若沒打就鎖總量
# Modify.........: No:CHI-B40060 11/06/07 By Summer 增加替代功能+批序+簽收的流程
# Modify.........: No:FUN-B40082 11/06/08 By kim 工單備置計算總量錯誤
# Modify.........: No:MOD-B60234 11/07/04 By Summer 沒有加上axmt628_icd,故g_prog='axmt628'請改為g_prog[1,7]='axmt628'
# Modify.........: No:MOD-B40139 11/07/17 By JoHung 境外倉出貨,境外倉庫存沒有批序號資料
# Modify.........: No:MOD-B80219 11/08/22 By suncx 更新img17時應同時更新img37，保持兩者一致
# Modify.........: No:MOD-BA0080 11/10/12 By johung 依參數sma894決定是否允許負庫存 (imgs_file)
# Modify.........: No:TQC-B90236 11/10/26 By zhuhao s_upimgs原程式段修改
#                                                   更新料件特性資料檔(inj_file)
# Modify.........: No.FUN-BA0023 11/11/29 By pauline 上傳的銷售/銷退單, 加入代銷功能
# Modify.........: No.FUN-BC0036 11/12/16 By jason 新增ICD刻號/BIN調整單庫存判斷
# Modify.........: No:FUN-C10037 12/01/11 By Mandy M-Client GP5.3-廢除WSUB將原WSUB併入原ERP的SUB,相關引響程式調整
# Modify.........: No:FUN-BC0061 12/02/24 By nanbing 增加almt700的程式判斷
# Modify.........: No:TQC-C20312 12/03/07 By yuhuabao 修改審核時沒有及時update inj06为Y的bug
# Modify.........: No:FUN-C30230 12/03/29 By xjll     增加 GWC 系統作業
# Modify.........: No:FUN-C50071 12/06/06 By Sakura add aimt306,aimt309
# Modify.........: No:TQC-C50128 12/06/07 By Elise 還原MOD-BA0080的調整
# Modify.........: No:CHI-A30032 12/06/15 By Elise 增加製程報費入庫批序號功能
# Modify.........: No:CHI-C60022 12/06/19 By Summer 寄銷出貨,境外存貨倉庫存沒有批序號資料
# Modify.........: No:FUN-C60036 12/06/29 By xuxz 添加axmt670的內容
# Modify.........: No:MOD-C60242 12/07/03 By Elise 執行庫存過帳後,在途倉的批序號庫存錯亂
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:MOD-C70055 12/07/10 By Elise 出貨單扣帳時，與tlf_file記錄的入庫數量不一致
# Modify.........: No:MOD-C70085 12/07/11 By Elise 修正MOD-C60242
# Modify.........: No:MOD-C70209 12/08/09 By ck2yuan 還原MOD-B80219的修改
# Modify.........: No:WEB-C90001 12/09/05 By jingll 增加wpct029的程式判斷
# Modify.........: No:FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No:MOD-C90220 12/10/15 By Vampire 出貨簽收不判斷l_ogb17='Y'
# Modify.........: No:MOD-CA0033 12/10/15 By Vampire 扣帳還原imgs08需加回驗退量
# Modify.........: No:FUN-CA0023 12/10/22 By qiaozy 添加wpct010信息
# Modify.........: No:FUN-CA0084 12/11/01 By xuxz 走開票流程且為大陸版的時候axmt700扣帳
# Modify.........: No:FUN-CB0085 12/11/23 By jingll 补過單
# Modify.........: No:MOD-CB0199 12/11/21 By Carrier 更新img前,检查ime资料是否存在,不存在则insert ime
# Modify.........: No:MOD-D30085 13/03/11 By ck2yuan 取代關係就被設定為失效,應考慮全部可用倉的數量，非其一個倉儲批數量為0. 
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No.DEV-D30026 13/03/15 By Nina GP5.3 追版:DEV-D20002以上為GP5.25 的單號
# Modify.........: No.TQC-D30047 13/03/19 By ck2yuan 修正MOD-D30085 
# Modify.........: No:TQC-D30054 13/03/21 By lixh1 FUN-D30024所做的修改在正式區被還原,故重新過單
# Modify.........: No:CHI-BB0057 13/03/25 By Vampire axmt628由出貨單轉入且oaz23='N'時，ogb17 預設 'N'
# Modify.........: No:CHI-D10014 13/04/03 By bart aimp700rvbs處理
# Modify.........: No:TQC-D40078 13/04/27 By fengrui 負庫存函数添加营运中心参数
# Modify.........: No.FUN-D40103 13/05/07 By fengrui ime_file添加imeacti
# Modify.........: No:FUN-D40103 13/05/10 By lixh1 增加儲位有效性檢查

IMPORT os    #FUN-9B0113
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_upimg(p_rowid,p_type ,p_qty2 ,p_date ,p_item ,   #FUN-8C0084
FUNCTION s_upimg(p_img01,p_img02,p_img03,p_img04,p_type ,p_qty2 ,p_date ,p_item ,#FUN-8C0084  #TQC-D30054
                 p_stock,p_locat,p_lot  ,p_no   ,p_line ,
                 p_unit ,p_qty  ,p_unit2,p_fac1 ,p_fac2 ,
                 p_fac3 ,p_act  ,p_proj ,m_pri  ,s_pri  ,
                 p_cla  ,p_ono)
DEFINE
    #No.TQC-9B0015  --Begin
   #p_rowid    LIKE type_file.chr18,
    p_rx       LIKE type_file.chr18,
    #No.TQC-9B0015  --End  
    p_type     LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    p_qty2     LIKE img_file.img10,
    p_date     LIKE img_file.img17, #異動日期
    p_item     LIKE img_file.img01,
    p_stock    LIKE img_file.img02,
    p_locat    LIKE img_file.img03,
    p_lot      LIKE img_file.img04,
    p_img01    LIKE img_file.img01,  #FUN-8C0084
    p_img02    LIKE img_file.img02,  #FUN-8C0084
    p_img03    LIKE img_file.img03,  #FUN-8C0084
    p_img04    LIKE img_file.img04,  #FUN-8C0084
    p_no       LIKE img_file.img05,
    p_line     LIKE img_file.img06,
    p_unit     LIKE img_file.img07,
    p_qty      LIKE img_file.img08,
    p_unit2    LIKE img_file.img09,
    p_fac1     LIKE img_file.img20,
    p_fac2     LIKE img_file.img21,
    p_fac3     LIKE img_file.img34,
    p_act      LIKE img_file.img26,
    p_cla      LIKE img_file.img19,
    p_ono      LIKE img_file.img36,
    p_proj     LIKE img_file.img35,
    m_pri      LIKE imf_file.imf06, #發料順序
    s_pri      LIKE imf_file.imf06, #銷售領料順序
    l_date     LIKE img_file.img17, #異動日期
    l_ima71    LIKE ima_file.ima71, #儲存有效天數
    l_img22    LIKE img_file.img22, #儲位類別
    l_img10_o  LIKE img_file.img10, #
    l_img23    LIKE img_file.img23, #可用倉儲
    l_img24    LIKE img_file.img24, #mrp 可用倉儲
    l_img25    LIKE img_file.img25, #保稅否
    s_qty      LIKE imf_file.imf04, #最高存量
    s_unit     LIKE imf_file.imf05, #庫存單位
    s_status   LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    l_sum1     LIKE imf_file.imf04,     #No.FUN-680147 DEC(16,3)
    l_sum2     LIKE imf_file.imf04,     #No.FUN-680147 DEC(16,3)
    l_msg      LIKE zaa_file.zaa08,     #No:8652 	#No.FUN-680147 VARCHAR(30)
    l_msg2     LIKE zaa_file.zaa08,     #MOD-530408 add	#No.FUN-680147 VARCHAR(100)
    l_flag     LIKE type_file.chr1                #是否控制庫存量不得為負(Y/N) 	#No.FUN-680147 VARCHAR(1)
 #--No.MOD-580191 add
DEFINE
    g_img10_old      LIKE img_file.img10,
    g_img10_new      LIKE img_file.img10,
    g_img01          LIKE img_file.img01,
    l_cmd            LIKE type_file.chr1000,	#No.FUN-680147 VARCHAR(500)
    l_str            LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(500)
#--end
DEFINE g_ima918   LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921   LIKE ima_file.ima921  #No.FUN-810036
DEFINE l_n        LIKE type_file.num5   #FUN-8C0084
DEFINE l_img RECORD LIKE img_file.*     #No.TQC-930155
DEFINE l_sig05    LIKE sig_file.sig05   #No.FUN-A20048 add
DEFINE l_img10    LIKE img_file.img10   #No.FUN-A20048 add 
DEFINE l_sie05    LIKE sie_file.sie05   #No.FUN-A20048 add
#DEFINE l_issue_flag  LIKE type_file.num5  #TQC-AC0298  #是否為發退料單過帳  #FUN-AC0074
DEFINE l_issue_flag  LIKE type_file.chr1   #FUN-AC0074             
DEFINE g_flag        LIKE type_file.chr1   #FUN-C80107 add
#add by zhangzs 210113  ----s------
IF p_ono = 'abcd' THEN
  LET g_prog[1,7]= 'abcdefg'
END IF 
#add by zhangzs 210113  ----e------
#FUN-A90049 -------------start------------------------------------   
#    IF s_joint_venture( p_item ,g_plant) OR NOT s_internal_item( p_item,g_plant ) THEN        #FUN-AB0011  mark
     IF s_joint_venture( p_img01 ,g_plant) OR NOT s_internal_item( p_img01,g_plant ) THEN        #FUN-AB0011
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
    #No.FUN-8C0084--BEGIN--
    IF g_prog[1,7]= 'aimp880' OR g_prog[1,7]= 'aimt307' OR 
       g_prog[1,7]= 'aimt337' OR g_prog[1,7]= 'aimp401' THEN
       SELECT count(*) INTO l_n FROM img_file
        WHERE img01 = p_img01
          AND img02 = p_img02
          AND img03 = p_img03
          AND img04 = p_img04
    #No.TQC-9B0015  --Begin
       IF l_n <= 0 THEN             #NO.TQC-9A0109
         #LET p_rowid = -3333
          LET p_rx    = -3333
       ELSE
         #LET p_rowid = -9999
          LET p_rx    = -9999
       END IF      
    ELSE
      #LET p_rowid = -9999
       LET p_rx    = -9999
    END IF
    #No.TQC-9B0015  --End  
    #No.FUN-8C0084--END--
 
    WHENEVER ERROR CALL cl_err_msg_log
    #單倉管理者, 在此不用麻煩了
    IF g_sma.sma12 != 'Y' THEN RETURN END IF
    #檢查更新方式是否正確
    # add p_type = 0 for 報廢
    IF p_type != 1 AND p_type != -1 AND p_type != 0  AND p_type != 2
       THEN RETURN
    END IF
 
#   LET l_issue_flag = FALSE  #TQC-AC0298  #FUN-AC0074
    LET l_issue_flag = ''     #FUN-AC0074 
    #FUN-8C0084--BEGIN--
    IF cl_null(p_img01) THEN LET p_img01 = ' ' END IF
    IF cl_null(p_img02) THEN LET p_img02 = ' ' END IF
    IF cl_null(p_img03) THEN LET p_img03 = ' ' END IF
    IF cl_null(p_img04) THEN LET p_img04 = ' ' END IF
    #FUN-8C0084--END--
 
    #No.MOD-CB0199  --Begin
    #check ime01=p_img01 & ime02 = p_img02 的ime_file资料是否存在,若不存在,则生成一笔
    CALL s_upimg_ins_ime(p_img02,p_img03)
    #No.MOD-CB0199  --End

    #TQC-620156...............begin
    IF cl_null(p_item) THEN
       SELECT img01 INTO p_item FROM img_file 
#No.FUN-8C0084--BEGIN--
#        WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
         WHERE img01=p_img01
           AND img02=p_img02
           AND img03=p_img03
           AND img04=p_img04
#No.FUN-8C0084--END--
    END IF
    #TQC-620156...............end
    #No.TQC-9B0015  --Begin
    #IF p_rowid!='-3333' THEN  #MOD-570005 add if 判斷
     IF p_rx   !='-3333' THEN  #MOD-570005 add if 判斷
    #No.TQC-9B0015  --End  
        SELECT img10 INTO l_img10_o FROM img_file
#No.FUN-8C0084--BEGIN--
#        WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
         WHERE img01=p_img01
           AND img02=p_img02
           AND img03=p_img03
           AND img04=p_img04
#No.FUN-8C0084--END--  
         #MOD-530408 add
        IF SQLCA.sqlcode THEN
            LET g_success='N'
            LET l_msg2=p_item CLIPPED,'/',p_stock CLIPPED,'/',p_locat CLIPPED,'/',p_lot CLIPPED
            #搜尋此"料/倉/儲/批"的庫存資料檔(img_file)時發生錯誤!
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('img01,img02,img03,img04',l_msg2,l_msg2,'aim-419',1)
            ELSE
               CALL cl_err(l_msg2,'aim-419',1)  #MOD-580117
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN
        END IF
         #MOD-530408(end)
    END IF
    ####################################################################
    ## 依主程式代號加上參數sma894決定是否控制庫存量不可為負
    LET l_flag = 'X' #MOD-570005 add
    LET g_flag = NULL   #FUN-C80107 add
    CASE 
         #(庫存不足是否許雜項發料及報廢)
         #No.+055 010404 by plum add aimp379,aimp378
         #WHEN g_prog='aimt301' OR g_prog='aimt302' OR g_prog='aimt303' OR 
         #    g_prog='aimt311' OR g_prog='aimt312' OR g_prog='aimt313'
         WHEN g_prog[1,7]='aimt301' OR g_prog[1,7]='aimt302' OR g_prog[1,7]='aimt303' OR 
              g_prog[1,7]='aimt311' OR g_prog[1,7]='aimt312' OR g_prog[1,7]='aimt313' OR
              g_prog='aimp379' OR g_prog='atmt243' OR g_prog='atmt244'     #NO.FUN-610074
               OR g_prog='aemt200' OR g_prog='aemt201' OR g_prog='aemt202' #MOD-530408 add
               OR g_prog='atmt260' OR g_prog='atmt261'  #FUN-610066 add
               OR g_prog='wmbt006' #FUN-C10037 add
               OR g_prog='apcp200'  #FUN-BA0023 add
               OR g_prog='almt700' #FUN-BC0061 add
               OR g_prog='wpct029' #WEB-C90001 add
               OR g_prog='wpct301' OR g_prog='wpct302' OR g_prog='wpct303' OR g_prog='wpcp379'  #FUN-C30230--add wpct301,wpct302,wpct303,wpcp379
               OR g_prog='cxcp001' 
             #IF g_sma.sma894[1,1]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],p_img02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_img02,g_plant) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
              LET l_issue_flag = '4'   #FUN-AC0074
 
         #(庫存不足是否允許出貨扣帳)
         WHEN g_prog[1,7]='axmt650' OR g_prog[1,7]='axmt610' OR g_prog[1,7]='axmt620' 
              OR g_prog='atmt242' OR g_prog='axmp650'   #No.FUN-610064 
             #OR g_prog='axmt627' OR g_prog='axmt628'   #No.FUN-610057 #MOD-B60234 mark
              OR g_prog='axmt627' OR g_prog[1,7]='axmt628'             #MOD-B60234 
              OR g_prog='axmt640'   #No.FUN-740016
              OR g_prog='axmp201'   #No.FUN-960071
              OR g_prog='wmbt015'   #No.FUN-C10037
              OR g_prog='atmt248'                       #No.FUN-630061
              OR g_prog='atmt321'                       #No.FUN-630102 add
              OR g_prog='axmp230'                       #No.TQC-730022 add
              OR g_prog='axmt670'      #FUN-C60036 add
              #No.3200 add
              OR g_prog='axmp820' OR g_prog='axmp900' OR g_prog='axmp830'
              OR g_prog='axmp901' 
	      ###### 01/11/20 Tommy Add
	      OR g_prog='axmp910' 
              OR g_prog='axmp911' 
	      ###### End Tommy
              #No.3200 end
              OR g_prog[1,7]='axmt820'  OR g_prog[1,7]='axmt821'   #MOD-530003  
             #IF g_sma.sma894[2,2]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],p_img02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 
              CALL s_inv_shrt_by_warehouse(p_img02,g_plant) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
              LET l_issue_flag = '3'   #FUN-AC0074 
 
         #(庫存不足是否允許工單發料退料過帳還原)
         WHEN g_prog[1,7]='asfi511' OR g_prog[1,7]='asfi512' OR g_prog[1,7]='asfi513' OR 
              g_prog[1,7]='asfi514' OR g_prog[1,7]='asfi526' OR g_prog[1,7]='asfi527' OR 
              g_prog[1,7]='asfi528' OR g_prog[1,7]='asfi529' OR g_prog[1,7]='asfi519' OR  #FUN-C70014  add g_prog[1,7]='asfi519'
              g_prog[1,7]='asfi510' OR g_prog[1,7]='asfi520' OR g_prog[1,7]='asri210' OR  #FUN-5C0114
              g_prog[1,7]='asri220' OR g_prog[1,7]='asri230' #FUN-5C0114
              OR g_prog[1,7]= 'abcdefg'   #add by zhangzs 210113
              OR g_prog = 'csft511'    #add by gujq 20160904
              OR g_prog = 'csft512'    #add by sunll 170616  
              OR g_prog='asfp510' OR g_prog='asfp520' #MOD-530408 add
              OR g_prog='wmbt010'  #FUN-C10037 add
              OR g_prog='abat021'  #DEV-D30026 add
             #IF g_sma.sma894[3,3]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],p_img02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_img02,g_plant) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
            # LET l_issue_flag = TRUE  #TQC-AC0298     #FUN-AC0074
              LET l_issue_flag = '1'   #FUN-AC0074 
         #(庫存不足是否允許調撥出庫)
         #No.+055 010404 by plum add aimp379,aimp378
         #WHEN g_prog='aimp400' OR g_prog='aimp401' OR g_prog='aimp700' OR 
         #     g_prog='aimp701' OR g_prog='aimt324' OR g_prog='aimt325'
         WHEN g_prog='aimp400' OR g_prog='aimp401' OR g_prog='aimp700' OR 
              g_prog='aimp701' OR g_prog[1,7]='aimt324' OR g_prog[1,7]='aimt325' OR
              g_prog='aimp378' OR g_prog = 'artt256'     #NO.FUN-960130---add art---#NO.FUN-9B0016
               OR g_prog[1,7]='artt262' OR g_prog[1,7]='artt263'  #No.FUN-A10037
               OR g_prog[1,7]='aimt326' #MOD-530408 add
               OR g_prog[1,7]='wmbt009' #FUN-C10037 add
               OR g_prog[1,7]='aict324' #FUN-BC0036 add
             #IF g_sma.sma894[4,4]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],p_img02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_img02,g_plant) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
              LET l_issue_flag = '5'   #FUN-AC0074  
              
         #(庫存不足是否允許還料出庫)
        #WHEN g_prog='aimt306' OR g_prog='aimt309' #FUN-A80106 mark
         WHEN g_prog[1,7]='aimt306' OR g_prog[1,7]='aimt309' #FUN-A80106
             #IF g_sma.sma894[5,5]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[5,5],p_img02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_img02,g_plant) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
              
         #(庫存不足是否允許採購退庫過帳及入庫過帳還原)
         WHEN g_prog[1,7]='apmt720' OR g_prog[1,7]='apmt721' OR g_prog[1,7]='apmt722' OR g_prog[1,7]='wpct010' OR #FUN-CA0023-ADD WPCT010 #FUN-CB0085
              g_prog[1,7]='apmt730' OR g_prog[1,7]='apmt731' OR g_prog[1,7]='apmt732' OR
              g_prog = 'wmbt013' OR g_prog='wmbt014' OR g_prog = 'wmbt002' OR  #FUN-C10037 add
              g_prog = 'wmbt003' OR g_prog = 'wmbt011' OR                      #FUN-C10037 add
	      ###### 01/11/19 Tommy Add
              g_prog[1,7]='apmt740' OR g_prog[1,7]='apmt732' OR
	      ###### End Tommy
              g_prog[1,7]='asft620' OR g_prog[1,7]='asft622'   #No.B404 add
               OR g_prog[1,7]='asrt320' #FUN-5C0114
               OR g_prog='asft623' OR g_prog='axdt203' #MOD-530408 add
               OR g_prog='axdt202' #MOD-570002 add
               #MOD-530003
              OR g_prog[1,7]='apmt740'  OR g_prog[1,7]='apmt741' OR g_prog[1,7]='apmt742' 
              #--
               #MOD-530037  
              OR g_prog[1,7]='asft700'  OR g_prog='asft730' 
              #--
              OR g_prog[1,7]='aict042' OR g_prog[1,7]='aict043'  #CHI-830025
              OR g_prog[1,7]='aict044' #CHI-830025
              OR g_prog[1,7]='artt724' OR g_prog[1,7]='artt725'  #No.FUN-A10037
              OR g_prog[1,7]='artt726' OR g_prog[1,7]='artt727'  #No.FUN-A10037
              OR g_prog[1,7]='artt603' OR g_prog[1,7]='artt604'  #FUN-B30012  ADD
             #IF g_sma.sma894[6,6]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[6,6],p_img02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_img02,g_plant) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
             
         #(庫存不足是否允許銷退過帳還原)
         #No.+055 010404 by plum add axmp870
         #WHEN g_prog='axmt700' OR g_prog='axmt840'
         WHEN g_prog[1,7]='axmt700' OR g_prog[1,7]='axmt840' OR g_prog='axmp750' OR
              g_prog='axmp870' OR g_prog='atmt252'    #No.FUN-610064 
             #IF g_sma.sma894[7,7]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[7,7],p_img02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_img02,g_plant) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
            
         #(是否允許盤點過帳後庫存為負)
         WHEN g_prog='aimp880' OR g_prog='aimt307' OR g_prog='aimp920'
              OR g_prog='artt215'  #No.FUN-A10037
             #IF g_sma.sma894[8,8]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[8,8],p_img02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_img02,g_plant) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
           
         OTHERWISE
              LET l_flag = 'N'
    END CASE
     #MOD-530408 add
     IF l_flag = 'N' AND p_type <= 0 THEN #MOD-570005 多AND p_type <= 0
        #系統並無此支程式在庫存不足時的相關設定,請程式人員修正s_upimg.4gl
        LET g_success='N'
        #-----No.FUN-6C0083-----
        IF g_bgerr THEN
           CALL s_errmsg('ima01',p_item,g_prog,'aim-409',1)
        ELSE
           CALL cl_err(g_prog,'aim-409',1)
        END IF
        RETURN
    END IF
     #MOD-530408(end)
    #################################################################
    LET l_msg='s_upimg:',p_no,'-',p_line USING '##&'  #No:8652
 
    #報廢時, 只要更新原有的, 就可以了 (david)
    IF p_type = 0 THEN  #報廢
       IF l_img10_o<p_qty2 AND p_qty2>0 AND l_flag = 'Y' THEN 
          LET g_success='N'
          #-----No.FUN-6C0083-----
          IF g_bgerr THEN
             CALL s_errmsg('ima01',p_item,l_msg,'aim-406',1)
          ELSE
             CALL cl_err(l_msg,'aim-406',1) 
          END IF
          #-----No.FUN-6C0083 END-----
          RETURN  #No:8652
       END IF
 #----No.MOD-580191 select出img10 進行計算後，在update img10
         LET g_img10_old = NULL
         LET g_img10_new = NULL
         SELECT img10 INTO g_img10_old FROM img_file 
#No.FUN-8C0084--END--
#         WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
          WHERE img01=p_img01
            AND img02=p_img02
            AND img03=p_img03
            AND img04=p_img04
#No.FUN-8C0084--END--  
         IF STATUS OR g_img10_old IS NULL THEN
            LET g_success='N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('ima01',p_item,'','aim-992',1)
            ELSE
               CALL cl_err(' ','aim-992',1)
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN
         END IF
         LET g_img10_old = g_img10_old - p_qty2
         UPDATE img_file
            SET img10=g_img10_old,   #庫存數量
               #img37=p_date,        #呆滯日期 MOD-B80219   #MOD-C70209 mark
                img17=p_date,        #異動日期
                img11=p_qty2
           #No.FUN-8C0084--begin--
           #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
            WHERE img01=p_img01
              AND img02=p_img02
              AND img03=p_img03
              AND img04=p_img04
           #No.FUN-8C0084--END--  
 
#        UPDATE img_file
#           SET img10=img10-p_qty2, #庫存數量
#               img17=p_date        #異動日期
#           WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
#---------end
           IF SQLCA.sqlcode   THEN
              LET g_success='N' 
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                 CALL s_errmsg('ima01',p_item,'','aim-992',1)
              ELSE
                 CALL cl_err(' ','aim-992',1)
              END IF
              #-----No.FUN-6C0083 END-----
              RETURN
           END IF
 #---------No.MOD-580191 比較update 後img10是否與異動後庫存量相等
        SELECT img01,img10 INTO g_img01,g_img10_new FROM img_file 
        #No.FUN-8C0084--BEGIN--
        #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
         WHERE img01=p_img01
           AND img02=p_img02
           AND img03=p_img03
           AND img04=p_img04
        #No.FUN-8C0084--END--  
       IF STATUS OR g_img10_new IS NULL THEN
           LET g_success='N'
           #-----No.FUN-6C0083-----
           IF g_bgerr THEN
              CALL s_errmsg('ima01',p_item,'','aim-992',1)
           ELSE
              CALL cl_err(' ','aim-992',1)
           END IF
           #-----No.FUN-6C0083 END-----
           RETURN
        END IF
        IF g_img10_new != g_img10_old THEN
           LET l_str = "料件: ",g_img01,"日期: ",p_date,"  異動數量: ",p_qty2,
                       "  g_img10_old: ",g_img10_old,"  g_img10_new: ",g_img10_new

         # LET l_cmd = "echo ",l_str CLIPPED," >> $TEMPDIR/upimg10.txt"     #FUN-9B0113
           LET l_cmd = "echo ",l_str CLIPPED," >> ",os.Path.join(FGL_GETENV("TEMPDIR"),"upimg10.txt")
           RUN l_cmd

           LET g_success='N'
           #-----No.FUN-6C0083-----
           IF g_bgerr THEN
              CALL s_errmsg('ima01',p_item,'','lib-028',1)
           ELSE
              CALL cl_err(' ','lib-028',1)
           END IF
           #-----No.FUN-6C0083 END-----
           RETURN
        END IF
#-------end
 
         CALL chk_img10_0(p_img01,p_img02,p_img03,p_img04,p_item,p_stock,p_locat,p_lot) #FUN-8C0084
         #-----No.FUN-810036-----
         SELECT ima918,ima921 INTO g_ima918,g_ima921 
           FROM ima_file
          WHERE ima01 = p_item
            AND imaacti = "Y"
        #MOD-B10120---add---start---
         IF STATUS = 100 THEN
            LET g_success='N'
            CALL cl_err(p_item,'atm-380',1)
         END IF
        #MOD-B10120---add---end---
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
           #CALL s_upimg_imgs(p_rowid,p_type,p_no,p_line,p_unit2)  #No.FUN-810036  #FUN-8C0084
            #CALL s_upimg_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2)  #No.FUN-8C0084   #MOD-A20117
            CALL s_upimg_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2,'1')  #No.FUN-8C0084   #MOD-A20117
         END IF
         #-----No.FUN-810036 END-----
         IF g_success = 'Y' THEN  #FUN-AB0055
            CALL s_upimg_upbmd(g_img10_old,p_qty2,p_img01)  #FUN-AB0055
         END IF #FUN-AB0055
        RETURN
    END IF
 
    #出庫時, 只要更新原有的, 就可以了
    IF p_type =-1 THEN  
#No.FUN-A20048 add--begin
#出庫  #如果存在备置档，判断库存时，需减去备置量。
       CALL s_sig(p_img01,p_img02,p_img03,p_img04,p_no,p_line,l_issue_flag) RETURNING l_sig05  #FUN-A20048 add #TQC-AC0298
       LET l_img10 = l_img10_o - l_sig05
      #IF l_sig05 > 0 AND l_img10 < p_qty2 AND p_qty2 > 0 THEN #FUN-CA0084 mark
       IF l_sig05 > 0 AND l_img10 < p_qty2 AND p_qty2 > 0 AND#FUN-CA0084 add
          NOT  (g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND g_aza.aza26 = '2' AND g_prog = 'axmt700') THEN#FUN-CA0084 add
          LET g_success ='N'
          DECLARE t610_curs_s CURSOR FOR SELECT sie05 FROM sie_file WHERE sie01 = p_img01 AND sie02 = p_img02 
                     AND sie03 = p_img03 AND sie04 = p_img04 AND sie11 > 0
          FOREACH t610_curs_s INTO l_sie05
             IF STATUS THEN LET l_sie05 =' ' END IF 
             EXIT FOREACH
          END FOREACH   
           IF g_bgerr THEN
              LET g_showmsg=p_item CLIPPED,'/',l_sie05 CLIPPED,'/',l_img10_o CLIPPED,'/',l_sig05 CLIPPED,'/',l_img10 CLIPPED
              CALL s_errmsg('ima01,sie05,img10,sig05,img10',g_showmsg,l_msg,'sie-001',1)
           ELSE
              CALL cl_err(l_msg,'sie-001',1)
           END IF
           #-----No.FUN-6C0083 END-----
           RETURN  #No:8652
       END IF
#No.FUN-A20048 add --end  
      #IF l_img10_o<p_qty2 AND p_qty2>0 AND l_flag = 'Y' THEN #FUN-CA0084 mark
       IF l_img10_o<p_qty2 AND p_qty2>0 AND l_flag = 'Y' AND  #FUN-CA0084 add
          NOT  (g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND g_aza.aza26 = '2' AND g_prog = 'axmt700') THEN#FUN-CA0084 add
          #CALL cl_err('upd img','asf-375',0) LET g_success='N' RETURN
           LET g_success='N'
           #-----No.FUN-6C0083-----
           IF g_bgerr THEN
              CALL s_errmsg('ima01',p_item,l_msg,'asf-375',1)
           ELSE
              CALL cl_err(l_msg,'asf-375',1)
           END IF
           #-----No.FUN-6C0083 END-----
           RETURN  #No:8652
       END IF
 #----No.MOD-580191 select出img10 進行計算後，在update img10
         LET g_img10_old = NULL
         LET g_img10_new = NULL
         SELECT img10 INTO g_img10_old FROM img_file 
         #No.FUN-8C0084--BEGIN--
         #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
          WHERE img01=p_img01
            AND img02=p_img02
            AND img03=p_img03
            AND img04=p_img04
        #No.FUN-8C0084--END--  
         IF STATUS OR g_img10_old IS NULL THEN
            LET g_success='N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('ima01',p_item,'','aim-992',1)
            ELSE
               CALL cl_err(' ','aim-992',1)
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN
         END IF
         LET g_img10_old = g_img10_old - p_qty2 
         UPDATE img_file
            SET img10=g_img10_old,   #庫存數量
                img16=p_date,
                img17=p_date,        #異動日期
               img37=p_date,        #呆滯日期 MOD-B80219  #MOD-C70209 mark #remark by darcy:2022/08/08
                img11=p_qty2
          #No.FUN-8C0084--BEGIN--
          #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
           WHERE img01=p_img01
             AND img02=p_img02
             AND img03=p_img03
             AND img04=p_img04
        #No.FUN-8C0084--END--  
 
#        UPDATE img_file
#           SET img10=img10-p_qty2, #庫存數量
#               img16=p_date,
#               img17=p_date        #異動日期
#           WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
#--------end
 
           IF SQLCA.sqlcode   THEN
              LET g_success='N'
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                 CALL s_errmsg('ima01',p_item,'(s_upimg:ckp#2)',SQLCA.sqlcode,1)
              ELSE
                #CALL cl_err('(s_upimg:ckp#2)',SQLCA.sqlcode,1) #FUN-670091
                 CALL cl_err3("upd","img_file","","",SQLCA.sqlcode,"","s_upimg:ckp#2",1)  #FUN-670091
              END IF
              #-----No.FUN-6C0083 END-----
              RETURN
           END IF
 #---------No.MOD-580191 比較update 後img10是否與異動後庫存量相等
        SELECT img01,img10 INTO g_img01,g_img10_new FROM img_file
              #No.FUN-8C0084--BEGIN--
              #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
               WHERE img01=p_img01
                 AND img02=p_img02
                 AND img03=p_img03
                 AND img04=p_img04
              #No.FUN-8C0084--END--  
        IF STATUS OR g_img10_new IS NULL THEN
           LET g_success='N'
           #-----No.FUN-6C0083-----
           IF g_bgerr THEN
              CALL s_errmsg('ima01',p_item,'','aim-992',1)
           ELSE
              CALL cl_err(' ','aim-992',1)
           END IF
           #-----No.FUN-6C0083 END-----
           RETURN
        END IF
        IF g_img10_new != g_img10_old THEN
           LET l_str = "料件: ",g_img01,"日期: ",p_date,"  異動數量: ",p_qty2,
                       "g_img10_old: ",g_img10_old,"  g_img10_new: ",g_img10_new

         # LET l_cmd = "echo ",l_str CLIPPED," >> $TEMPDIR/upimg10.txt"    #FUN-9B0113
           LET l_cmd = "echo ",l_str CLIPPED," >> ",os.Path.join(FGL_GETENV("TEMPDIR"),"upimg10.txt")
           RUN l_cmd

           LET g_success='N'
           #-----No.FUN-6C0083-----
           IF g_bgerr THEN
              CALL s_errmsg('ima01',p_item,'','lib-028',1)
           ELSE
              CALL cl_err(' ','lib-028',1)
           END IF
           #-----No.FUN-6C0083 END-----
           RETURN
        END IF
#-------end
 
         CALL chk_img10_0(p_img01,p_img02,p_img03,p_img04,p_item,p_stock,p_locat,p_lot) #FUN-8C0084
         #-----No.FUN-810036-----
         SELECT ima918,ima921 INTO g_ima918,g_ima921 
           FROM ima_file
          WHERE ima01 = p_item
            AND imaacti = "Y"
        #MOD-B10120---add---start---
         IF STATUS = 100 THEN
            LET g_success='N'
            CALL cl_err(p_item,'atm-380',1)
         END IF
        #MOD-B10120---add---end---
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
           #CALL s_upimg_imgs(p_rowid,p_type,p_no,p_line,p_unit2)  #No.FUN-810036 #No.FUN-8C0084
            #CALL s_upimg_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2)  #No.FUN-8C0084   #MOD-A20117
            CALL s_upimg_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2,'1')  #No.FUN-8C0084   #MOD-A20117
         END IF
         #-----No.FUN-810036 END-----
         IF g_success = 'Y' THEN  #FUN-AB0055
            CALL s_upimg_upbmd(g_img10_old,p_qty2,p_img01)  #FUN-AB0055
         END IF #FUN-AB0055
        RETURN
    END IF
    #入庫時, 稍為麻煩點, 因為不確定該筆是否已經存在
    #No.TQC-9B0015  --Begin
   #IF p_rowid!='-3333' THEN #原明細資料存在
    IF p_rx   !='-3333' THEN #原明細資料存在
    #No.TQC-9B0015  --End  
       IF (l_img10_o+p_qty2)<0 AND p_qty2<0 AND l_flag = 'Y' THEN 
          #CALL cl_err('upd img','asf-375',0) LET g_success='N' RETURN
           LET g_success='N'
           #-----No.FUN-6C0083-----
           IF g_bgerr THEN
              CALL s_errmsg('ima01',p_item,l_msg,'aim-406',1)
           ELSE
              CALL cl_err(l_msg,'aim-406',1)  
           END IF
           #-----No.FUN-6C0083 END-----
           LET g_success='N' RETURN  #No:8652
       END IF
       IF p_type = 2 THEN  #盤點
 #----No.MOD-580191 select出img10 進行計算後，在update img10
         LET g_img10_old = NULL
         LET g_img10_new = NULL
         SELECT img10 INTO g_img10_old FROM img_file
         #No;FUN-8C0084--BEGIN-- 
         #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
          WHERE img01=p_img01
            AND img02=p_img02
            AND img03=p_img03
            AND img04=p_img04
          #No.FUN-8C0084--END--  
         IF STATUS OR g_img10_old IS NULL THEN
            LET g_success='N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('ima01',p_item,'','aim-992',1)
            ELSE
               CALL cl_err(' ','aim-992',1)
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN
         END IF
         LET g_img10_old = g_img10_old + p_qty2
         UPDATE img_file
            SET img10=g_img10_old,   #庫存數量
                img14=p_date,
                img17=p_date,        #異動日期
                img37=p_date,        #呆滯日期 MOD-B80219 #MOD-C70209 mark #remakr by darcy:2022/08/08
                img11=p_qty2
         #No.FUN-8C0084--BEGIN--
         #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
          WHERE img01=p_img01
            AND img02=p_img02
            AND img03=p_img03
            AND img04=p_img04
          #No.FUN-8C0084--END--  
#---mark
#{ckp#3}    UPDATE img_file
#              SET img10=img10+p_qty2, #庫存數量 + 盤盈虧數量
#                  img14=p_date,       #盤點日期
#                  img17=p_date        #異動日期
#              WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
#----end
 
           IF SQLCA.sqlcode   THEN
              LET g_success='N' 
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                 CALL s_errmsg('ima01',p_item,'(s_upimg:ckp#3)',SQLCA.sqlcode,1)
              ELSE
                #CALL cl_err('(s_upimg:ckp#3)',SQLCA.sqlcode,1)    #FUN-670091
                 CALL cl_err3("upd","img_file","","",SQLCA.sqlcode,"","s_upimg:ckp#3",1)  #FUN-670091
              END IF
              #-----No.FUN-6C0083 END-----
              RETURN
           END IF
 #---------No.MOD-580191 比較update 後img10是否與異動後庫存量相等
           SELECT img01,img10 INTO g_img01,g_img10_new FROM img_file
           #No;FUN-8C0084--BEGIN--
           #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
            WHERE img01=p_img01
              AND img02=p_img02
              AND img03=p_img03
              AND img04=p_img04
          #No.FUN-8C0084--END--  
           IF STATUS OR g_img10_new IS NULL THEN
              LET g_success='N'
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                 CALL s_errmsg('ima01',p_item,'','aim-992',1)
              ELSE
                 CALL cl_err(' ','aim-992',1)
              END IF
              #-----No.FUN-6C0083 END-----
              RETURN
           END IF
           IF g_img10_new != g_img10_old THEN
              LET l_str = "料件: ",g_img01,"日期: ",p_date," 異動數量: ",p_qty2,
                         "g_img10_old: ",g_img10_old,"g_img10_new: ",g_img10_new

            # LET l_cmd = "echo ",l_str CLIPPED," >> $TEMPDIR/upimg10.txt"   #FUN-9B0113
              LET l_cmd = "echo ",l_str CLIPPED," >> ",os.Path.join(FGL_GETENV("TEMPDIR"),"upimg10.txt")
              RUN l_cmd

              LET g_success='N'
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                 CALL s_errmsg('ima01',p_item,'','lib-028',1)
              ELSE
                 CALL cl_err(' ','lib-028',1)
              END IF
              #-----No.FUN-6C0083 END-----
              RETURN
           END IF
#-------end
       ELSE 
 #----No.MOD-580191 select出img10 進行計算後，在update img10
         LET g_img10_old = NULL
         LET g_img10_new = NULL
         SELECT img10 INTO g_img10_old FROM img_file 
           #No.FUN-8C0084--BEGIN--
           #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
            WHERE img01=p_img01
              AND img02=p_img02
              AND img03=p_img03
              AND img04=p_img04
          #No.FUN-8C0084--END--  
         IF STATUS OR g_img10_old IS NULL THEN
            LET g_success='N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('ima01',p_item,'','aim-992',1)
            ELSE
               CALL cl_err(' ','aim-992',1)
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN
         END IF
         LET g_img10_old = g_img10_old + p_qty2
         #darcy:2022/04/21 s---
         # 库存数量为0时，同步更新呆滞日期
         UPDATE img_file
            SET img37=p_date 
           WHERE img01=p_img01
             AND img02=p_img02
             AND img03=p_img03
             AND img04=p_img04
             AND img10 = 0
         #darcy:2022/04/21 e--- 
         UPDATE img_file
            SET img10=g_img10_old,   #庫存數量
                img15=p_date,
                img17=p_date,        #異動日期
               img37=p_date,        #呆滯日期 MOD-B80219 #MOD-C70209 mark  #remark by darcy
                img11=p_qty2
           #No.FUN-8C0084--BEGIN--
           #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
            WHERE img01=p_img01
              AND img02=p_img02
              AND img03=p_img03
              AND img04=p_img04
          #No.FUN-8C0084--END--  
#----mark
#{ckp#4}    UPDATE img_file
#              SET img10=img10+p_qty2, #庫存數量
#                  img15=p_date,       #最近收料日期
#                  img17=p_date        #異動日期
#              WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
#----end
 
           IF SQLCA.sqlcode   THEN
              LET g_success='N' 
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                 CALL s_errmsg('ima01',p_item,'(s_upimg:ckp#4)',SQLCA.sqlcode,1)
              ELSE
                #CALL cl_err('(s_upimg:ckp#4)',SQLCA.sqlcode,1)  #FUN-670091
                 CALL cl_err3("upd","img_file","","",SQLCA.sqlcode,"","s_upimg:ckp#4",1) #FUN-670091
              END IF
              #-----No.FUN-6C0083 END-----
              RETURN
           END IF
 #---------No.MOD-580191 比較update 後img10是否與異動後庫存量相等
           SELECT img01,img10 INTO g_img01,g_img10_new FROM img_file
           #No.FUN-8C0084--BEGIN--
           #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
            WHERE img01=p_img01
              AND img02=p_img02
              AND img03=p_img03
              AND img04=p_img04
          #No.FUN-8C0084--END--  
           IF STATUS OR g_img10_new IS NULL THEN
              LET g_success='N'
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                 CALL s_errmsg('ima01',p_item,'','aim-992',1)
              ELSE
                 CALL cl_err(' ','aim-992',1)
              END IF
              #-----No.FUN-6C0083 END-----
              RETURN
           END IF
           IF g_img10_new != g_img10_old THEN
              LET l_str = "料件: ",g_img01,"日期: ",p_date,"異動數量: ",p_qty2,
                         "g_img10_old: ",g_img10_old,"g_img10_new: ",g_img10_new

            # LET l_cmd = "echo ",l_str CLIPPED," >> $TEMPDIR/upimg10.txt"    #FUN-9B0113
              LET l_cmd = "echo ",l_str CLIPPED," >> ",os.Path.join(FGL_GETENV("TEMPDIR"),"upimg10.txt")
              RUN l_cmd

              LET g_success='N'
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                 CALL s_errmsg('ima01',p_item,'','lib-028',1)
              ELSE
                 CALL cl_err(' ','lib-028',1)
              END IF
              #-----No.FUN-6C0083 END-----
              RETURN
           END IF
#-------end
 
       END IF
        CALL chk_img10_0(p_img01,p_img02,p_img03,p_img04,p_item,p_stock,p_locat,p_lot) #No.FUN-8C0084
         #-----No.FUN-810036-----
         SELECT ima918,ima921 INTO g_ima918,g_ima921 
           FROM ima_file
          WHERE ima01 = p_item
            AND imaacti = "Y"
        #MOD-B10120---add---start---
         IF STATUS = 100 THEN
            LET g_success='N'
            CALL cl_err(p_item,'atm-380',1)
         END IF
        #MOD-B10120---add---end---
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
           #CALL s_upimg_imgs(p_rowid,p_type,p_no,p_line,p_unit2)  #No.FUN-810036 #FUN-8C0084
            #CALL s_upimg_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2)  #No.FUN-8C0084   #MOD-A20117
            CALL s_upimg_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2,'1')  #No.FUN-8C0084   #MOD-A20117
         END IF
         #-----No.FUN-810036 END-----
         IF g_success = 'Y' THEN  #FUN-AB0055
            CALL s_upimg_upbmd(g_img10_old,p_qty2,p_img01)  #FUN-AB0055
         END IF #FUN-AB0055
       RETURN
    END IF
#--->盤虧時, 不新增庫存明細
    IF p_type = 2 AND p_qty2 < 0  THEN RETURN END IF
    #取得該料件的儲存有效天數
    SELECT ima71 INTO l_ima71
        FROM ima_file
        WHERE ima01=p_item
    IF SQLCA.sqlcode OR l_ima71 IS NULL THEN
        LET l_ima71=0
    END IF
    IF l_ima71 =0 THEN LET  l_date=g_lastdat
                  ELSE LET l_date=DATE(p_date+l_ima71)
    END IF

    #add by huzhou 170807 针对调拨料件，不去更新img18字段

   IF g_prog = "aimt324" THEN 
      SELECT img18 INTO l_date  FROM img_file
       WHERE img01 = p_img01
	 AND img02 = p_img02
	 AND img03 = p_img03
	 AND img04 = p_img04
    DISPLAY l_date
   END IF
   #end  huzhou 170807

    #取得儲位性質
   #IF p_locat IS NOT NULL THEN
    IF NOT cl_null(p_locat) THEN
        SELECT ime04,ime05,ime06,ime07
            INTO l_img22,l_img23,l_img24,l_img25
            FROM ime_file
            WHERE ime01=p_stock AND
                  ime02=p_locat
                  AND imeacti = 'Y'   #FUN-D40103
    ELSE
        SELECT imd10,imd11,imd12,imd13
            INTO l_img22,l_img23,l_img24,l_img25
            FROM imd_file
            WHERE imd01=p_stock
    END IF
   IF SQLCA.SQLCODE THEN LET l_img23='Y' LET l_img24='Y' END IF
    IF p_stock IS NULL THEN LET p_stock= ' ' END IF   #MOD-490056
   IF p_locat IS NULL THEN LET p_locat= ' ' END IF
   IF p_lot IS NULL THEN LET p_lot=' ' END IF
   IF p_fac1 IS NULL THEN LET p_fac1=1 END IF
   IF p_fac2 IS NULL THEN LET p_fac2=1 END IF
   IF p_fac3 IS NULL THEN LET p_fac3=1 END IF
   CALL s_hqty(p_item,p_stock,p_locat) RETURNING s_status,s_qty,s_unit 
   IF s_qty IS NULL THEN LET s_qty=0 END IF
#No.TQC-930155-start-
#{ckp#5} INSERT INTO img_file
#              1      2       3       4     5    6
#        VALUES(p_item,p_stock,p_locat,p_lot,p_no,p_line,
#       7      8     9       10     11 12 13        
#        p_unit,p_qty,p_unit2,p_qty2, 0, 0, null, #NO:7522
#       14     15     16     17     18                    
#        p_date,p_date,p_date,p_date,l_date,
#       19     20     21     22      23      24      25
#        p_cla,p_fac1,p_fac2,l_img22,l_img23,l_img24,l_img25,
#       26    27   28     30 31 32 33, 34     35     36   37
#        p_act,m_pri,s_pri, 0, 0, 0, 0, p_fac3,p_proj,p_ono,p_date)   #MOD-8C0132
#       p_act,m_pri,s_pri, 0, 0, 0, 0, p_fac3,p_proj,p_ono,null)     #MOD-8C0132 mark
        LET l_img.img01 = p_item
        LET l_img.img02 = p_stock
        LET l_img.img03 = p_locat
        LET l_img.img04 = p_lot
        LET l_img.img05 = p_no
        LET l_img.img06 = p_line
        LET l_img.img07 = p_unit
        LET l_img.img08 = p_qty
        LET l_img.img09 = p_unit2
        LET l_img.img10 = p_qty2
        LET l_img.img11 = 0
        LET l_img.img12 = 0
        LET l_img.img13 = NULL
        LET l_img.img14 = p_date
        LET l_img.img15 = p_date
        LET l_img.img16 = p_date
        LET l_img.img17 = p_date
        LET l_img.img18 = l_date
        LET l_img.img19 = p_cla
        LET l_img.img20 = p_fac1
        LET l_img.img21 = p_fac2
        LET l_img.img22 = l_img22
        LET l_img.img23 = l_img23
        LET l_img.img24 = l_img24
        LET l_img.img25 = l_img25
        LET l_img.img26 = p_act
        LET l_img.img27 = m_pri
        LET l_img.img28 = s_pri
        LET l_img.img30 = 0
        LET l_img.img31 = 0
        LET l_img.img32 = 0
        LET l_img.img33 = 0
        LET l_img.img34 = p_fac3
        LET l_img.img35 = p_proj
        LET l_img.img36 = p_ono
        LET l_img.img37 = p_date
        LET l_img.imgplant = g_plant  #No.FUN-870007
        LET l_img.imglegal = g_legal  #No.FUN-870007
        INSERT INTO img_file VALUES (l_img.*)
#No.TQC-930155--end--
           IF SQLCA.sqlcode THEN
              LET g_success='N' 
              #-----No.FUN-6C0083-----
              IF g_bgerr THEN
                 CALL s_errmsg('ima01',p_item,'(s_upimg:ckp#5)',SQLCA.sqlcode,1)
              ELSE
                #CALL cl_err('(s_upimg:ckp#5)',SQLCA.sqlcode,1)  #FUN-670091
                 CALL cl_err3("ins","img_file","","",SQLCA.sqlcode,"","s_upimg:ckp#5",1)  #FUN-670091
              END IF
              #-----No.FUN-6C0083 END-----
              RETURN
           END IF
 
    #(@@)成本問題尚未解決
 
    #--------- 97/06/18 AIM 3.0 產品會議 : check 最高存量限制
    SELECT SUM(img10*img21) INTO l_sum1 FROM img_file   #MOD-940312
        WHERE img01=p_item AND img02=p_stock AND img03=p_locat
    IF STATUS OR l_sum1 IS NULL THEN LET l_sum1=0 END IF
    SELECT imf04 INTO l_sum2 FROM imf_file
        WHERE imf01=p_item AND imf02=p_stock AND imf03=p_locat
    IF STATUS OR l_sum2 IS NULL THEN RETURN END IF
    IF l_sum1>l_sum2 THEN
       LET g_success='N' 
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_item,'(ckp#6)','aim-390',1)
       ELSE
          CALL cl_err('(ckp#6) ','aim-390',1)
       END IF
       #-----No.FUN-6C0083 END-----
       RETURN
    END IF 
    #-----------------------------------
 
         #-----No.FUN-810036-----
         SELECT ima918,ima921 INTO g_ima918,g_ima921 
           FROM ima_file
          WHERE ima01 = p_item
            AND imaacti = "Y"
        #MOD-B10120---add---start---
         IF STATUS = 100 THEN
            LET g_success='N'
            CALL cl_err(p_item,'atm-380',1)
         END IF
        #MOD-B10120---add---end---
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
           #CALL s_upimg_imgs(p_rowid,p_type,p_no,p_line,p_unit2)  #No.FUN-810036 #FUN-8C0084
            #CALL s_upimg_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2)  #No.FUN-8C0084   #MOD-A20117
            CALL s_upimg_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2,'1')  #No.FUN-8C0084   #MOD-A20117
         END IF
         #-----No.FUN-810036 END-----
         IF g_success = 'Y' THEN  #FUN-AB0055
            CALL s_upimg_upbmd(g_img10_old,p_qty2,p_img01)  #FUN-AB0055
         END IF #FUN-AB0055
END FUNCTION
 
#FUN-AB0055(S)
FUNCTION s_upimg_upbmd(p_img10,p_qty2,p_img01)
DEFINE p_img10   LIKE img_file.img10
DEFINE p_qty2    LIKE img_file.img10
DEFINE p_img01   LIKE img_file.img01
DEFINE l_qty     LIKE img_file.img10   #MOD-D30085 add

  IF g_sma.sma145 = 'Y' THEN
    #MOD-D30085 str add-----
     SELECT SUM(img10) INTO l_qty FROM img_file,imd_file        #TQC-D30047 add imd_file 
      WHERE img01=p_img01 AND img02=imd01 AND imd11='Y' 
    #MOD-D30085 end add-----
    #IF p_img10 = 0 AND p_qty2 > 0 THEN                  #MOD-D30085 mark
     IF p_img10 = 0 AND p_qty2 > 0 AND l_qty = 0 THEN    #MOD-D30085 add
        UPDATE bmd_file SET bmd06 = g_today
         WHERE bmd04 = p_img01
           AND bmd02 = '1'
           AND bmdacti = 'Y'
           AND bmd06 IS NULL
     END IF
  END IF
END FUNCTION
#FUN-AB0055(E)

#FUNCTION chk_img10_0(l_item,l_stock,l_locat,l_lot) #MOD-530408 add 多傳 料/倉/儲/批#FUN-8C0084
 FUNCTION chk_img10_0(l_img01,l_img02,l_img03,l_img04,l_item,l_stock,l_locat,l_lot) #FUN-8C0084 多傳 料/倉/儲/批
    DEFINE l_img10 LIKE img_file.img10
 #MOD-530408 add
   DEFINE l_msg2     LIKE zaa_file.zaa08        #No.FUN-680147 VARCHAR(100)
   DEFINE l_item     LIKE img_file.img01
   DEFINE l_stock    LIKE img_file.img02
   DEFINE l_locat    LIKE img_file.img03
   DEFINE l_lot      LIKE img_file.img04
 #MOD-530408(end)
 #No.FUN-8C0084--BEGIN--
   DEFINE l_img01    LIKE img_file.img01
   DEFINE l_img02    LIKE img_file.img02
   DEFINE l_img03    LIKE img_file.img03
   DEFINE l_img04    LIKE img_file.img04
 #No.FUN-8C0084--END--
 
    #CHI-740011---mark---str---
    #IF g_sma.sma882='Y' THEN  #CHI-710041 mark 
    #   IF l_rowid!='-3333' THEN #MOD-570005 add if 判斷
    #      SELECT img10 INTO l_img10 FROM img_file WHERE rowid=l_rowid
    #       #MOD-530408 add
    #      IF SQLCA.sqlcode THEN
    #          #搜尋此"料/倉/儲/批"的庫存資料檔(img_file)時發生錯誤!
    #          LET l_msg2=l_item CLIPPED,'/',l_stock CLIPPED,'/',l_locat CLIPPED,'/',l_lot CLIPPED
    #          #-----No.FUN-6C0083-----
    #          IF g_bgerr THEN
    #             CALL s_errmsg('img01,img02,img03,img04',l_msg2,l_msg2,'aim-419',1)
    #          ELSE
    #             CALL cl_err(l_msg2,'aim-419',1)  #MOD-580117
    #          END IF
    #          #-----No.FUN-6C0083 END-----
    #          LET g_success='N'
    #          RETURN
    #      END IF
    #       #MOD-530408(end)
    #      IF l_img10=0 THEN 
    #         DELETE FROM img_file WHERE rowid=l_rowid
    #          #MOD-530408 add
    #         IF SQLCA.sqlcode THEN
    #             #刪除此"料/倉/儲/批"的庫存資料檔(img_file)時發生錯誤!
    #             LET l_msg2=l_item CLIPPED,'/',l_stock CLIPPED,'/',l_locat CLIPPED,'/',l_lot CLIPPED
    #             #-----No.FUN-6C0083-----
    #             IF g_bgerr THEN
    #                CALL s_errmsg('img01,img02,img03,img04',l_msg2,l_msg2,'aim-408',1)
    #             ELSE
    #                CALL cl_err(l_msg2,'aim-408',1)
    #             END IF
    #             #-----No.FUN-6C0083 END-----
    #             LET g_success='N'
    #             RETURN
    #         END IF
    #          #MOD-530408(end)
    #      END IF
    #  END IF
    #END IF  
    #CHI-740011---mark---end---
 
END FUNCTION
 
#-----No.FUN-810036-----
#FUNCTION s_upimg_imgs(p_rowid,p_type,p_no,p_line,p_unit2) #FUN-8C0084
#FUNCTION s_upimg_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2) #FUN-8C0084   #MOD-A20117
FUNCTION s_upimg_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2,p_type2) #FUN-8C0084   #MOD-A20117
   DEFINE p_type     LIKE type_file.num5,
          p_no       LIKE img_file.img05,
          p_line     LIKE img_file.img06,
          p_unit2    LIKE img_file.img09,
          p_type2    LIKE type_file.num5,   #MOD-A20117  #'1'-->由s_upimg呼叫,'2'-->由單支程式呼叫
          #FUN-8C0084--BEGIN--
          p_img01    LIKE img_file.img01, 
          p_img02    LIKE img_file.img02, 
          p_img03    LIKE img_file.img03, 
          p_img04    LIKE img_file.img04
          #FUN-8C0084--END-- 
   DEFINE l_sql   STRING
   DEFINE l_rvbs  RECORD LIKE rvbs_file.*
   DEFINE l_imgs08   LIKE imgs_file.imgs08
   DEFINE l_rvbs09   LIKE rvbs_file.rvbs09
   DEFINE l_img01    LIKE img_file.img01
   DEFINE l_img02    LIKE img_file.img02 
   DEFINE l_img03    LIKE img_file.img03
   DEFINE l_img04    LIKE img_file.img04
   DEFINE l_img09    LIKE img_file.img09
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE l_ogb17    LIKE ogb_file.ogb17   #No.FUN-870131
   DEFINE l_ogc18    LIKE ogc_file.ogc18   #No.FUN-870131
   DEFINE l_cnt      LIKE type_file.num5   #MOD-9A0172
   DEFINE l_imd10    LIKE imd_file.imd10   #No.MOD-AA0086
DEFINE l_imgs RECORD LIKE imgs_file.*   #No.TQC-930155
   DEFINE l_cnt1     LIKE type_file.num5   #CHI-AC0034 add
   DEFINE l_no       LIKE img_file.img05   #CHI-B40060 add
   DEFINE l_oga011   LIKE oga_file.oga011  #CHI-B40060 add
   DEFINE l_oga65    LIKE oga_file.oga65   #CHI-B40060 add
   DEFINE l_chose    LIKE type_file.num5   #TQC-B90236 add
   IF g_success = "N" THEN
      RETURN
   END IF
 
#No.FUN-8A0147--begin
   IF g_prog[1,7]= 'aimp880' OR g_prog[1,7]= 'aimp920' THEN 
      RETURN
   END IF
#No.FUN-8A0147--end

   #No.MOD-AA0086  --Begin
   #aimt325/aimt326 时WIP仓,不做批序号控管
   #原因:拨出审核时,WIP时若写rvbs等内容的话,会和拨入时的内容相重复
   #     拨入审核时,WIP时若写rvbs等内容的话,会和拨出时的内容相重复
   IF g_prog = 'aimt325' OR g_prog = 'aimt326' THEN
      SELECT imd10 INTO l_imd10 FROM imd_file
       WHERE imd01 = p_img02
      IF cl_null(l_imd10) THEN LET l_imd10 = 'S' END IF
      IF l_imd10 = 'W' OR l_imd10 = 'w' THEN
         RETURN
      END IF
   END IF
   #No.MOD-AA0086  --End  
 
   SELECT img01,img02,img03,img04,img09
     INTO l_img01,l_img02,l_img03,l_img04,l_img09
     FROM img_file
   #No;FUN-8C0084--BEGIN--
   #WHERE img01=p_item AND img02=p_stock AND img03=p_locat AND img04=p_lot
    WHERE img01=p_img01
      AND img02=p_img02
      AND img03=p_img03
      AND img04=p_img04
    #No.FUN-8C0084--END--  
 
   IF l_img02 IS NULL THEN LET l_img02= ' ' END IF 
   IF l_img03 IS NULL THEN LET l_img03= ' ' END IF
   IF l_img04 IS NULL THEN LET l_img04= ' ' END IF
 
   #-----No.MOD-840244-----
   SELECT ima918,ima921 INTO l_ima918,l_ima921 
     FROM ima_file
    WHERE ima01 = l_img01
      AND imaacti = "Y"
   
   #-----No.MOD-840251-----
   IF cl_null(l_ima918) THEN
      LET l_ima918='N'
   END IF
                                                                                
   IF cl_null(l_ima921) THEN
      LET l_ima921='N'
   END IF
   #-----No.MOD-840251 END-----
 
   IF l_ima918 = "N" AND l_ima921 = "N" THEN
      RETURN
   END IF
   #-----No.MOD-840244 END-----
 
   #-----No.FUN-870131-----
   IF g_prog[1,7]='axmt610' OR g_prog[1,7]='axmt620' OR g_prog='axmp650' OR
      g_prog='axmt820' OR g_prog[1,7]='axmt821' OR #MOD-B30020 add   
      g_prog='wmbt015' OR  #FUN-C10037 add  
      g_prog='axmt650' OR g_prog[1,7]='axmt628' OR g_prog[1,7]='axmt629'THEN    #MOD-A20117 #CHI-AC0034 add 628,629
      SELECT ogb17 INTO l_ogb17 FROM ogb_file
       WHERE ogb01 = p_no 
         AND ogb03 = p_line
      IF l_ogb17 = "Y" THEN
         #-----MOD-A20117---------
         IF NOT (g_sma.sma115 = 'Y' AND p_type2='1')THEN    
            IF g_sma.sma115='Y' AND p_type2='2' THEN   
               SELECT ogg18 INTO l_ogc18 FROM ogg_file
                WHERE ogg01 = p_no
                  AND ogg03 = p_line
                  AND ogg10 = p_unit2 
                  AND ogg09 = l_img02
                  AND ogg091 = l_img03
                  AND ogg092 = l_img04
            ELSE
         #-----END MOD-A20117-----
               SELECT ogc18 INTO l_ogc18 FROM ogc_file
                WHERE ogc01 = p_no
                  AND ogc03 = p_line
                  AND ogc17 = l_img01
                  AND ogc09 = l_img02
                  AND ogc091 = l_img03
                  AND ogc092 = l_img04
            END IF   #MOD-A20117
         END IF   #MOD-A20117
      END IF
   END IF
 
   IF cl_null(l_ogc18) THEN
      LET l_ogc18 = 0 
   END IF
   #-----No.FUN-870131 END-----
 
   LET l_rvbs09 = 0
 
   IF g_prog[1,7]='aimt302' OR g_prog[1,7]='aimt312' OR                         
      g_prog[1,7]='apmt110' OR g_prog[1,7]='apmt200' OR
      g_prog[1,7]='aimt306' OR                             #FUN-C50071 add
      g_prog[1,7]='apmt720' OR g_prog[1,7]='apmt730' OR      #TQC-B90236 add
     #g_prog[1,7]='apmt720' OR g_prog[1,7]='apmt740' OR      #TQC-B90236 mark
     #g_prog[1,7]='apmt721' OR                               #TQC-B90236 mark
     #g_prog[1,7]='apmt722' OR g_prog[1,7]='apmt730' OR      #TQC-B90236 mark                   
     #g_prog[1,7]='apmt731' OR g_prog[1,7]='apmt732' OR      #TQC-B90236 mark                   
      g_prog[1,7]='asft620' OR g_prog[1,7]='asft622' OR 
      g_prog[1,7]='asft700' OR                               #No:CHI-A30032 add                      
      g_prog[1,7]='apmt740' OR                               #TQC-B90236 add
      g_prog[1,7]='axmt629' OR g_prog='axmp750' OR           #TQC-B90236 add
      g_prog='axmt700'      OR g_prog='axmt840' OR           #TQC-B90236 add
      g_prog[1,7]='asfi520' OR                               #TQC-B90236 add
      g_prog[1,7]='asfi526' OR g_prog[1,7]='asfi527' OR      #TQC-B90236 add
      g_prog[1,7]='asfi528' OR g_prog[1,7]='asfi529' OR      #TQC-B90236 add
     #g_prog[1,7]='apmt742' OR    #MOD-A90100                #TQC-B90236 mark
      g_prog[1,7]='asft623' OR g_prog[1,7]='asrt320' THEN  # MOD-8A0045                                                
      LET l_rvbs09 = 1                                                          
   END IF                                                                       
                                                                                
   IF g_prog[1,7]='aimt301' OR g_prog[1,7]='aimt311' OR                         
      g_prog[1,7]='aimt303' OR g_prog[1,7]='aimt313' OR  #MOD-910104 add                        
      g_prog[1,7]='aimt309' OR                           #FUN-C50071 add
      g_prog[1,7]='axmt610' OR g_prog[1,7]='axmt620' OR                         
     #g_prog='axmt628' OR g_prog='axmt629' OR g_prog='axmt640' OR        #MOD-B60234 mark       
     #g_prog[1,7]='axmt628' OR g_prog[1,7]='axmt629' OR g_prog='axmt640' OR   #MOD-B60234       #TQC-B90236 mark
      g_prog[1,7]='axmt628' OR g_prog='axmt640' OR                                              #TQC-B90236 add     
      g_prog='axmt820' OR g_prog='axmt821' OR g_prog='axmt650' OR               
     #g_prog[1,7]='asfi510' OR g_prog[1,7]='asfi520' OR                                         #TQC-B90236 mark
      g_prog[1,7]='asfi510' OR
      g_prog[1,7]='asfi511' OR g_prog[1,7]='asfi519' OR g_prog[1,7]='asfi512' OR                #FUN-C70014 add g_prog[1,7]='asfi519'           
      g_prog[1,7]='asfi513' OR g_prog[1,7]='asfi514' OR
     #g_prog[1,7]='asfi526' OR g_prog[1,7]='asfi527' OR   #No.MOD-870202                        #TQC-B90236 mark
     #g_prog[1,7]='asfi528' OR g_prog[1,7]='asfi529' OR   #No.MOD-870202                        #TQC-B90236 mark
      g_prog='asri210' OR g_prog='asri220' OR g_prog='asri230' OR   #No.CHI-870007
      g_prog='axmp650' OR
     #g_prog='axmp750' OR   #MOD-910150                                                         #TQC-B90236 mark 
      g_prog='wmbt015' OR   #FUN-C10037
      g_prog='wpct301' OR g_prog='wpct302' OR g_prog='wpct303' OR  #FUN-C30230--add wpct301,wpct302,wpct303
      g_prog='wmbt010' OR   #FUN-C10037
     #g_prog='axmt700' THEN     #NO.FUN-860025          #MOD-960279 mark               
     #g_prog='axmt700' OR g_prog='axmt840' THEN		#MOD-960279                             #TQC-B90236 mark
      g_prog[1,7]='apmt721' OR g_prog[1,7]='apmt722' OR g_prog[1,7]='wpct010' OR                #TQC-B90236 add  #FUN-CA0023-ADD WPCT010 #FUN-CB0085 
      g_prog[1,7]='apmt731' OR g_prog[1,7]='apmt732' OR                                         #TQC-B90236 add
      g_prog[1,7]='apmt742' THEN                                                                #TQC-B90236 add
      LET l_rvbs09 = -1     
   END IF                                                                       
 
   IF l_rvbs09 = 0 THEN                                                         
      IF p_type = -1 OR p_type = 0 THEN
         LET l_rvbs09 = -1
      END IF
                                                                                
      IF p_type = 1 OR p_type = 2 THEN
         LET l_rvbs09 = 1
      END IF
                                                                                
      IF g_prog = "aimp379" OR g_prog = "aimp378"  OR g_prog='wpcp379' THEN    #MOD-910150 取消mark   #FUN-C30230--add g_prog='wpcp379'
      #IF g_prog = "aimp379" OR g_prog = "aimp378" OR g_prog='axmp750' THEN   #NO.FUN-860025   #MOD-910150 mark
         LET l_rvbs09 = l_rvbs09 * -1
      END IF
      #No.MOD-AA0086  --Begin
      IF g_prog = 'aimt325 ' AND g_action_choice = 'undo_transfer_out' OR  
         g_prog = 'aimt326 ' AND g_action_choice = 'undo_transfer_in'  THEN
         LET l_rvbs09 = l_rvbs09 * -1
      END IF
      #No.MOD-AA0086  --End  
   END IF
 
   IF p_type = -1 OR p_type = 0 THEN
      #-----MOD-9A0172---------
      #判斷若是出貨簽收的"簽收在途倉",
      #因為l_ogc18的值不存在,且沒有rvbs_file的資料,
      #所以要抓取原出貨單的rvbs_file資料,故將rvbs13的條件拿掉
      #境外倉出貨同上   #MOD-B40139
      #寄銷出貨同上     #CHI-C60022
      LET l_cnt = 0 
      SELECT count(*) INTO l_cnt FROM oga_file
         WHERE oga66=l_img02 AND oga67=l_img03
           AND oga65='Y' AND oga01=p_no
           AND oga09='2'
           OR  (oga910=l_img02 AND oga911=l_img03   #MOD-B40139 add
          #AND oga00='3' AND oga01=p_no             #MOD-B40139 add #CHI-C60022 mark
           AND oga00 IN ('3','7') AND oga01=p_no                    #CHI-C60022
           AND oga09='2')                           #MOD-B40139 add
      #CHI-AC0034 add --start--
      LET l_cnt1 = 0
      SELECT count(*) INTO l_cnt1 FROM oga_file
         WHERE oga66=l_img02 AND oga67=l_img03
           AND oga01=p_no
           AND oga09='8'
      #CHI-AC0034 add --end--
      #CHI-B40060 add --start--
      LET l_no = p_no
     #IF g_prog = 'axmt628' AND g_oaz.oaz23 = 'Y' AND l_ogb17 = 'Y' THEN      #MOD-B60234 mark
      #IF g_prog[1,7] = 'axmt628' AND g_oaz.oaz23 = 'Y' AND l_ogb17 = 'Y' THEN #MOD-B60234 #MOD-C90220 mark
      #IF g_prog[1,7] = 'axmt628' AND g_oaz.oaz23 = 'Y' THEN #MOD-C90220 add #CHI-BB0057 mark
      IF g_prog[1,7] = 'axmt628' THEN #CHI-BB0057 add
         SELECT oga011 INTO l_oga011 FROM oga_file
          WHERE oga01= p_no
         SELECT oga65 INTO l_oga65 FROM oga_file
          WHERE oga01= l_oga011
         IF l_oga65 = 'Y' THEN
            LET l_no = l_oga011 
         END IF
      END IF
      #CHI-B40060 add --end--
     #IF g_prog='axmp650' AND l_cnt > 0 THEN #CHI-AC0034 mark   
     #IF (g_prog='axmp650' AND l_cnt > 0) OR (g_prog='axmp650' AND l_cnt1 > 0) THEN #CHI-AC0034  #CHI-BB0057 mark 
      IF (g_prog='axmp650' AND l_cnt > 0) OR (g_prog='axmp650' AND l_cnt1 > 0) OR (g_prog[1,7] = 'axmt628' AND l_cnt1 > 0) THEN #CHI-BB0057 add
       #MOD-C70055---mark---S---
       ##MOD-C60242---S---
       # IF g_oaz.oaz23='Y' THEN 
       #    IF g_sma.sma115='N' THEN
       #       SELECT ogc18 INTO l_ogc18 FROM ogc_file
       #        WHERE ogc01 = p_no 
       #          AND ogc03 = p_line
       #          AND ogc17 = l_img01
       #          AND ogc092 = l_img04
       #    END IF
       # END IF
       ##MOD-C60242---E--- 
       #MOD-C70055---mark---E---
         LET l_sql = "SELECT * FROM rvbs_file ",
                     "   WHERE rvbs01 = '",l_no,"'", #CHI-B40060 mod p_no->l_no 
                     "     AND rvbs02 = ",p_line, 
                     "     AND rvbs09 = ",l_rvbs09, #CHI-AC0034 add ,
                     "     AND rvbs021 = '",l_img01,"'"  #CHI-AC0034 add   #MOD-B40139 加上''
        #MOD-C60242---S---                          
        #IF g_oaz.oaz23='Y' THEN  #MOD-C70085 mark
         IF l_ogb17 = 'Y' THEN    #MOD-C70085
            IF g_sma.sma115='N' THEN
               #CHI-BB0057 add start -----
               IF g_prog[1,7] = 'axmt628' THEN
                  LET l_sql = l_sql,
                           "     AND rvbs13 IN ( ",
                           "         SELECT ogc18 FROM ogc_file ",
                           "          WHERE ogc01 = '",l_no,"'",
                           "            AND ogc03 = '",p_line,"'",
                           "            AND ogc17 = '",l_img01,"'",
                           "            AND ogc092 = '",l_img04,"' ) "
               ELSE
               #CHI-BB0057 add end   -----
                  LET l_sql = l_sql,
                          #MOD-C70055---S--- 
                          #"     AND rvbs13 = ",l_ogc18 
                           "     AND rvbs13 IN ( ",
                           "         SELECT ogc18 FROM ogc_file ",
                           "          WHERE ogc01 = '",p_no,"'",
                           "            AND ogc03 = '",p_line,"'",
                           "            AND ogc17 = '",l_img01,"'",
                           "            AND ogc092 = '",l_img04,"' ) "
                          #MOD-C70055---E---
               END IF #CHI-BB0057 add
            END IF
         END IF
        #MOD-C60242---E---
      ELSE
      #-----END MOD-9A0172-----
         #CHI-D10014---begin
         IF g_prog = "aimp700" THEN
            LET l_sql = "SELECT * FROM rvbs_file ",
                     " WHERE rvbs00 = '",g_prog,"'",
                     "   AND rvbs01 = '",l_no,"'", 
                     "   AND rvbs02 = ",p_line,
                     "   AND rvbs09 = ",l_rvbs09,   
                     "   AND rvbs13 = ",l_ogc18  
         ELSE 
         #CHI-D10014---end
            LET l_sql = "SELECT * FROM rvbs_file ",
                     #  " WHERE rvbs00 = '",g_prog,"'",
                        " WHERE rvbs01 = '",l_no,"'", #CHI-B40060 mod p_no->l_no
                        "   AND rvbs02 = ",p_line,
                        "   AND rvbs09 = ",l_rvbs09,
                        "   AND rvbs13 = ",l_ogc18    #No.FUN-870131
         END IF  #CHI-D10014 
      END IF   #MOD-9A0172
      
      PREPARE rvbs_pre FROM l_sql
      DECLARE rvbs_cs CURSOR FOR rvbs_pre
      
      FOREACH rvbs_cs INTO l_rvbs.*
         IF STATUS THEN 
            IF g_bgerr THEN 
               CALL s_errmsg('','','foreach:',STATUS,1)
            ELSE
               CALL cl_err('foreach:',STATUS,1)
            END IF
            EXIT FOREACH
         END IF
      
         LET l_imgs08 = NULL
      
         SELECT imgs08 INTO l_imgs08
           FROM imgs_file
          WHERE imgs01 = l_img01
            AND imgs02 = l_img02
            AND imgs03 = l_img03
            AND imgs04 = l_img04
            AND imgs05 = l_rvbs.rvbs03
            AND imgs06 = l_rvbs.rvbs04
            AND imgs11 = l_rvbs.rvbs08
      
         IF STATUS OR l_imgs08 IS NULL THEN
            LET g_success='N'
            IF g_bgerr THEN
               CALL s_errmsg('ima01',l_img01,'imgs_file','asf-375',1)
            ELSE
               CALL cl_err('imgs_file','asf-375',1)
            END IF
            RETURN
         END IF
      
         LET l_imgs08 = l_imgs08 - l_rvbs.rvbs06
         #-----MOD-920321---------
         IF l_imgs08 < 0 THEN                               #MOD-BA0080 mark  #TQC-C50128 remark
        #IF l_imgs08 < 0 AND g_sma.sma894[1,1] = 'N' THEN   #MOD-BA0080       #TQC-C50128 mark
            LET g_success='N'
            IF g_bgerr THEN
               CALL s_errmsg('ima01',l_img01,'imgs_file','asf-375',1)
            ELSE
               CALL cl_err('imgs_file','asf-375',1)
            END IF
            RETURN
         END IF
         #-----END MOD-920321-----
         UPDATE imgs_file
            SET imgs08=l_imgs08       #庫存數量
          WHERE imgs01 = l_img01
            AND imgs02 = l_img02
            AND imgs03 = l_img03
            AND imgs04 = l_img04
            AND imgs05 = l_rvbs.rvbs03
            AND imgs06 = l_rvbs.rvbs04
            AND imgs11 = l_rvbs.rvbs08
      
         IF SQLCA.sqlcode   THEN
            LET g_success='N' 
            IF g_bgerr THEN
               CALL s_errmsg('ima01',l_img01,'upd imgs','asf-375',1)
            ELSE
               CALL cl_err('upd imgs','asf-375',1)
            END IF
            RETURN
         END IF
      END FOREACH
   END IF
 
   IF p_type = 1 OR p_type = 2 THEN
      #-----MOD-9A0172---------
      #判斷若是出貨簽收的"簽收在途倉",
      #因為l_ogc18的值不存在,且沒有rvbs_file的資料,
      #所以要抓取原出貨單的rvbs_file資料,故將rvbs13的條件拿掉
      #境外倉出貨同上   #MOD-B40139
      #寄銷出貨同上     #CHI-C60022
      LET l_cnt = 0 
      SELECT count(*) INTO l_cnt FROM oga_file
         WHERE oga66=l_img02 AND oga67=l_img03
           AND oga65='Y' AND oga01=p_no
           AND oga09='2'
           OR  (oga910=l_img02 AND oga911=l_img03   #MOD-B40139
          #AND oga00='3' AND oga01=p_no             #MOD-B40139 add #CHI-C60022 mark
           AND oga00 IN ('3','7') AND oga01=p_no                    #CHI-C60022
           AND oga09='2')                           #MOD-B40139
      #CHI-AC0034 add --start--
      LET l_cnt1 = 0 
      SELECT count(*) INTO l_cnt1 FROM oga_file
         WHERE oga66=l_img02 AND oga67=l_img03
           AND oga01=p_no
           AND oga09='8' 
      #CHI-AC0034 add -end--
      #CHI-B40060 add --start--
      LET l_no = p_no
      #IF g_prog = 'axmp650' AND g_oaz.oaz23 = 'Y' AND l_ogb17 = 'Y' THEN #MOD-CA0033 mark
      #IF g_prog = 'axmp650' AND g_oaz.oaz23 = 'Y' THEN                    #MOD-CA0033 add #CHI-BB0057 mark
      IF g_prog = 'axmp650' THEN                    #CHI-BB0057 add
         SELECT oga011 INTO l_oga011 FROM oga_file
          WHERE oga01= p_no
         SELECT oga65 INTO l_oga65 FROM oga_file
          WHERE oga01= l_oga011
            AND oga09 = '2'
         IF l_oga65 = 'Y' THEN
            LET l_no = l_oga011 
         END IF
      END IF
      #CHI-B40060 add --end--
     #IF g_prog='axmt620' AND l_cnt > 0 THEN   #CHI-AC0034 mark 
     #IF (g_prog='axmt620' AND l_cnt > 0) OR (g_prog='axmt628' AND l_cnt1 > 0) THEN   #CHI-AC0034  #MOD-B60234 mark
     #IF (g_prog[1,7]='axmt620' AND l_cnt > 0) OR (g_prog[1,7]='axmt628' AND l_cnt1 > 0) THEN   #MOD-B60234  #FUN-C10037 mark
     #IF (g_prog[1,7]='axmt620' AND l_cnt > 0) OR (g_prog[1,7]='axmt628' AND l_cnt1 > 0) OR (g_prog[1,7]='wmbt015' AND l_cnt > 0)THEN   #MOD-B60234  #FUN-C10037 add #CHI-BB0057 mark
      IF (g_prog[1,7]='axmt620' AND l_cnt > 0) OR (g_prog[1,7]='axmt628' AND l_cnt1 > 0) OR (g_prog[1,7]='wmbt015' AND l_cnt > 0) OR (g_prog[1,7]='axmp650' AND l_cnt1 > 0) THEN   #CHI-BB0057
       #MOD-C70055---mark--s---
       ##MOD-C60242---S---
       # IF g_oaz.oaz23='Y' THEN  
       #    IF g_sma.sma115='N' THEN 
       #       SELECT ogc18 INTO l_ogc18 FROM ogc_file 
       #        WHERE ogc01 = p_no
       #          AND ogc03 = p_line
       #          AND ogc17 = l_img01
       #          AND ogc092 = l_img04
       #    END IF
       # END IF
       ##MOD-C60242---E--- 
       #MOD-C70055---mark--e---
         LET l_sql = "SELECT * FROM rvbs_file ",
                     "   WHERE rvbs01 = '",l_no,"'", #CHI-B40060 mod p_no->l_no 
                     "     AND rvbs02 = ",p_line, 
                     "     AND rvbs09 = ",l_rvbs09, #CHI-AC0034 add , 
                     "     AND rvbs021 = '",l_img01,"'"  #CHI-AC0034 add   #MOD-B40139 加上''
        #MOD-C60242---S---
        #IF g_oaz.oaz23='Y' THEN  #MOD-C70085 mark
         IF l_ogb17 = 'Y' THEN    #MOD-C70085 
            IF g_sma.sma115='N' THEN 
               #CHI-BB0057 add start -----
               IF g_prog[1,7] = 'axmp650' THEN
                  LET l_sql = l_sql,
                           "     AND rvbs13 IN ( ",
                           "         SELECT ogc18 FROM ogc_file ",
                           "          WHERE ogc01 = '",l_no,"'",
                           "            AND ogc03 = '",p_line,"'",
                           "            AND ogc17 = '",l_img01,"'",
                           "            AND ogc092 = '",l_img04,"' ) "
               ELSE
               #CHI-BB0057 add end   -----
                  LET l_sql = l_sql,
                          #MOD-C70055---S---
                          #"     AND rvbs13 = ",l_ogc18   #MOD-C70055 mark 
                           "     AND rvbs13 IN ( ",
                           "         SELECT ogc18 FROM ogc_file ",
                           "          WHERE ogc01 = '",p_no,"'",
                           "            AND ogc03 = '",p_line,"'",
                           "            AND ogc17 = '",l_img01,"'",
                           "            AND ogc092 = '",l_img04,"' ) "
                          #MOD-C70055---E---
               END IF #CHI-BB0057 add
            END IF
         END IF
        #MOD-C60242---E---
      ELSE
      #-----END MOD-9A0172-----
         #CHI-D10014---begin
         IF g_prog = "aimp700" THEN
            LET l_sql = "SELECT * FROM rvbs_file ",
                     " WHERE rvbs00 = '",g_prog,"'",
                     "   AND rvbs01 = '",l_no,"'", 
                     "   AND rvbs02 = ",p_line,
                     "   AND rvbs09 = ",l_rvbs09,   
                     "   AND rvbs13 = ",l_ogc18  
         ELSE 
         #CHI-D10014---end
            LET l_sql = "SELECT * FROM rvbs_file ",
                    #   " WHERE rvbs00 = '",g_prog,"'",
                        " WHERE rvbs01 = '",l_no,"'", #CHI-B40060 mod p_no->l_no
                        "   AND rvbs02 = ",p_line,
                        "   AND rvbs09 = ",l_rvbs09,
                        "   AND rvbs13 = ",l_ogc18    #No.FUN-870131
         END IF  #CHI-D10014 
      END IF   #MOD-9A0172
      
      PREPARE rvbs1_pre FROM l_sql
      DECLARE rvbs1_cs CURSOR FOR rvbs1_pre
      
      FOREACH rvbs1_cs INTO l_rvbs.*
         IF STATUS THEN 
            IF g_bgerr THEN 
               CALL s_errmsg('','','foreach:',STATUS,1)
            ELSE
               CALL cl_err('foreach:',STATUS,1)
            END IF
            EXIT FOREACH
         END IF
#TQC-C20312 ----- add ----- begin
         SELECT COUNT(*) INTO l_chose
           FROM inj_file
          WHERE inj01 = l_img01
            AND inj02 = l_rvbs.rvbs04
            AND inj06 = 'N'
         IF l_chose>0 THEN
            UPDATE inj_file SET inj06 = 'Y'
             WHERE inj01 = l_img01
               AND inj02 = l_rvbs.rvbs04
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               IF g_bgerr THEN
                  CALL s_errmsg('ima01',l_img01,'upd ing','inj-001',1)
               ELSE
                  CALL cl_err('upd inj','inj-001',1)
               END IF
               RETURN
            END IF
         END IF
#TQC-C20312 ----- add ----- end
      
         LET l_imgs08 = NULL
      
         SELECT imgs08 INTO l_imgs08
           FROM imgs_file
          WHERE imgs01 = l_img01
            AND imgs02 = l_img02
            AND imgs03 = l_img03
            AND imgs04 = l_img04
            AND imgs05 = l_rvbs.rvbs03
            AND imgs06 = l_rvbs.rvbs04
            AND imgs11 = l_rvbs.rvbs08
      
         IF STATUS = 100 THEN
#No.TQC-930155-start-
#            INSERT INTO imgs_file VALUES(l_img01,l_img02,l_img03,l_img04,
#                                         l_rvbs.rvbs03,l_rvbs.rvbs04,
#                                        #-----------No.MOD-840312 modify
#                                        #l_img09,l_rvbs.rvbs03,
#                                        #l_rvbs.rvbs04,l_rvbs.rvbs07,
#                                         l_img09,l_rvbs.rvbs06,
#                                         l_rvbs.rvbs05,l_rvbs.rvbs07,
#                                        #-----------No.MOD-840312 end
#                                         l_rvbs.rvbs08)
            LET l_imgs.imgs01 = l_img01
            LET l_imgs.imgs02 = l_img02
            LET l_imgs.imgs03 = l_img03
            LET l_imgs.imgs04 = l_img04
            LET l_imgs.imgs05 = l_rvbs.rvbs03
            LET l_imgs.imgs06 = l_rvbs.rvbs04
            LET l_imgs.imgs07 = l_img09
            LET l_imgs.imgs08 = l_rvbs.rvbs06
            LET l_imgs.imgs09 = l_rvbs.rvbs05
            LET l_imgs.imgs10 = l_rvbs.rvbs07
            LET l_imgs.imgs11 = l_rvbs.rvbs08
            LET l_imgs.imgsplant = g_plant  #No.FUN-870007
            LET l_imgs.imgslegal = g_legal  #No.FUN-870007
            INSERT INTO imgs_file VALUES(l_imgs.*)
#No.TQC-930155--end--
            IF SQLCA.sqlcode THEN
               LET g_success='N' 
               IF g_bgerr THEN
                  CALL s_errmsg('imgs01',l_img01,'(s_upimgs)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","imgs_file","","",SQLCA.sqlcode,"","s_upimgs",1)
               END IF
               RETURN
            END IF
            CONTINUE FOREACH
         ELSE
            IF STATUS OR l_imgs08 IS NULL THEN
               LET g_success='N'
               IF g_bgerr THEN
                  CALL s_errmsg('ima01',l_img01,'imgs_file','asf-375',1)
               ELSE
                  CALL cl_err('imgs_file','asf-375',1)
               END IF
               RETURN
            END IF 
         END IF
      
         LET l_imgs08 = l_imgs08 + l_rvbs.rvbs06
         UPDATE imgs_file
            SET imgs08=l_imgs08,      #庫存數量
                imgs09=l_rvbs.rvbs05
          WHERE imgs01 = l_img01
            AND imgs02 = l_img02
            AND imgs03 = l_img03
            AND imgs04 = l_img04
            AND imgs05 = l_rvbs.rvbs03
            AND imgs06 = l_rvbs.rvbs04
            AND imgs11 = l_rvbs.rvbs08
      
         IF SQLCA.sqlcode   THEN
            LET g_success='N' 
            IF g_bgerr THEN
               CALL s_errmsg('ima01',l_img01,'upd imgs','asf-375',1)
            ELSE
               CALL cl_err('upd imgs','asf-375',1)
            END IF
            RETURN
         END IF
#No.TQC-B90236-----------------add-----------start-------
##TQC-C20312 -----  mark ----- begin
#        SELECT COUNT(*) INTO l_chose 
#          FROM inj_file
#         WHERE inj01 = l_img01
#           AND inj02 = l_rvbs.rvbs04
#           AND inj06 = 'N'
#        IF l_chose>0 THEN 
#           UPDATE inj_file SET inj06 = 'Y'
#            WHERE inj01 = l_img01
#              AND inj02 = l_rvbs.rvbs04
#           IF SQLCA.sqlcode THEN
#              LET g_success='N'
#              IF g_bgerr THEN
#                 CALL s_errmsg('ima01',l_img01,'upd ing','inj-001',1)
#              ELSE
#                 CALL cl_err('upd inj','inj-001',1)
#              END IF
#              RETURN
#           END IF
#        END IF
##TQC-C20312 -----  mark ----- end
#No.TQC-B90236-----------------add-----------end---------
      END FOREACH
   END IF
 
END FUNCTION
#-----No.FUN-810036 END-----
  #No.FUN-850100
#No.CHI-870027
#FUN-A20048 --begin--杂发/调拨等出库作业，考虑库存变更为 库存-备置img10-sig05
FUNCTION s_sig(p_img01,p_img02,p_img03,p_img04,p_no,p_line,l_issue_flag)	 #TQC-AC0298
 DEFINE l_sig05 LIKE sig_file.sig05,
       #l_img10 LIKE img_file.img10, #TQC-AC0298
        p_img01 LIKE img_file.img01,
        p_img02 LIKE img_file.img02,
        p_img03 LIKE img_file.img03,
        p_img04 LIKE img_file.img04
# DEFINE l_issue_flag LIKE type_file.num5  #TQC-AC0298  #FUN-AC0074     
  DEFINE l_issue_flag LIKE type_file.chr1  #FUN-AC0074  
  DEFINE l_sfs RECORD LIKE sfs_file.*  #TQC-AC0298
  DEFINE l_sie11 LIKE sie_file.sie11   #TQC-AC0298
  DEFINE p_no         LIKE img_file.img05  #TQC-AC0298
  DEFINE p_line       LIKE img_file.img06  #TQC-AC0298
#FUN-AC0074 ---------------Begin----------------
  DEFINE l_sig05_cross  LIKE sig_file.sig05 # 跨倉未處理量
  DEFINE l_img10_other  LIKE img_file.img10 # 他倉存貨
  DEFINE l_img09_fac    LIKE img_file.img34
  DEFINE l_cnt          LIKE type_file.num5
  DEFINE l_ima25        LIKE ima_file.ima25 
  DEFINE l_img09        LIKE img_file.img09
  DEFINE l_oeb01        LIKE oeb_file.oeb01 
  DEFINE l_oeb03        LIKE oeb_file.oeb03 
#FUN-AC0074 ---------------End------------------
   #TQC-AC0298(S)
   #SELECT img10 INTO l_img10 FROM img_file WHERE img01 = p_img01 AND img02 = p_img02
   #          AND img03 = p_img03 AND img04 = p_img04
   #TQC-AC0298(E)

   #TQC-AC0298(S)
   LET l_sie11=0
 # IF l_issue_flag THEN  #發料單要排除本張工單的未備置量   #FUN-AC0074 
   IF l_issue_flag IS NOT NULL THEN #發料單要排除本張工單的未備置量   #FUN-AC0074
      CASE l_issue_flag     #FUN-AC0074
         WHEN '1'  #發料單  #FUN-AC0074
      SELECT * INTO l_sfs.* FROM sfs_file WHERE sfs01=p_no AND sfs02=p_line
      SELECT SUM(sie11) INTO l_sie11 FROM sie_file 
       WHERE sie01  = p_img01
      #  AND sie02  = p_img02                   #FUN-AC0074
         AND (sie02  = p_img02 OR sie02 = ' ')  #FUN-AC0074
         AND sie03  = p_img03
         AND sie04  = p_img04
         AND sie05  = l_sfs.sfs03
         AND sie06  = l_sfs.sfs10
         AND sie07  = l_sfs.sfs06
         AND sie08  = l_sfs.sfs27
         AND sie012 = l_sfs.sfs012
         AND sie013 = l_sfs.sfs013
   #FUN-AC0074 -----------------Begin-------------------------
         WHEN '3'  #出貨單
            SELECT ogb31,ogb32 INTO l_oeb01,l_oeb03 
                               FROM ogb_file 
                              WHERE ogb01=p_no AND ogb03=p_line
            IF NOT cl_null(l_oeb01) THEN
               SELECT SUM(sie11) INTO l_sie11 FROM sie_file 
                WHERE sie01  = p_img01
                  AND (sie02 = p_img02 OR sie02 = ' ')
                  AND sie03  = p_img03
                  AND sie04  = p_img04
                  AND sie05  = l_oeb01
                  AND sie15  = l_oeb03
            END IF
         WHEN '4'  #雜發單
            SELECT SUM(sie11) INTO l_sie11 FROM sie_file 
             WHERE sie01  = p_img01
               AND (sie02 = p_img02 OR sie02 = ' ')
               AND sie03  = p_img03
               AND sie04  = p_img04
               AND sie05  = p_no
               AND sie15  = p_line
         WHEN '5'  #調撥單
            SELECT SUM(sie11) INTO l_sie11 FROM sie_file 
             WHERE sie01  = p_img01
               AND (sie02 = p_img02 OR sie02 = ' ')
               AND sie03  = p_img03
               AND sie04  = p_img04
               AND sie05  = p_no
               AND sie15  = p_line
      END CASE
   #FUN-AC0074 ---------------------End----------------------- 
   IF cl_null(l_sie11) THEN LET l_sie11 =0 END IF  #TQC-B10143                 
   END IF  
   #TQC-AC0298(E)
   SELECT sig05 INTO l_sig05 FROM sig_file WHERE sig01 = p_img01 AND sig02 = p_img02
             AND sig03 = p_img03 AND sig04 = p_img04 

   #TQC-AC0298(S)
   #IF cl_null(l_img10) OR l_img10 = 0 THEN 
   #   LET l_img10 = 0
   #END IF 
   #TQC-AC0298(E)

   IF cl_null(l_sig05) THEN 
      LET l_sig05 = 0
   END IF

   #LET l_img10 = l_img10 - l_sig05
   #FUN-AC0074 ---------------------Begin--------------------------- 
   #檢查是否有跨倉備置,若有的話,先由他倉吸收,如果他倉的總存貨不足以處理跨倉的備置未處理量的話,剩餘量才由本倉吸收
   SELECT sig05 INTO l_sig05_cross 
                FROM sig_file 
               WHERE sig01 = p_img01 AND sig02 = ' '
                 AND sig03 = p_img03 AND sig04 = p_img04 
   IF l_sig05_cross IS NULL THEN LET l_sig05_cross = 0 END IF
   IF l_sig05_cross > 0 THEN
      SELECT SUM(img10*img21) INTO l_img10_other FROM img_file     #FUN-B40082
                        WHERE img01 = p_img01 AND img02 <> p_img02
                          AND img03 = p_img03 AND img04 = p_img04
      IF l_img10_other IS NULL THEN LET l_img10_other = 0 END IF
      IF l_img10_other > 0 THEN
         SELECT img09,ima25 INTO l_img09,l_ima25 FROM img_file 
                 LEFT OUTER JOIN ima_file ON (ima01=img01)
                     WHERE img01 = p_img01 AND img02 = p_img02
                       AND img03 = p_img03 AND img04 = p_img04
         CALL s_umfchk(p_img01,l_ima25,l_img09) RETURNING l_cnt,l_img09_fac
         IF l_cnt = 1 THEN LET l_img09_fac = 1 END IF
         LET l_img10_other = l_img10_other * l_img09_fac
      END IF
      LET l_sig05_cross = l_sig05_cross - l_img10_other
      IF l_sig05_cross < 0 THEN LET l_sig05_cross = 0 END IF
   END IF
   #FUN-AC0074 ---------------------End-----------------------------
  #LET l_sig05 = l_sig05 - l_sie11 #TQC-AC0298       #FUN-AC0074  
   LET l_sig05 = l_sig05 + l_sig05_cross - l_sie11   #FUN-AC0074

   RETURN l_sig05

END FUNCTION   
#FUN-A20048 add --end 


#No.MOD-CB0199  --Begin
FUNCTION s_upimg_ins_ime(p_ime01,p_ime02)
   DEFINE p_ime01     LIKE ime_file.ime01
   DEFINE p_ime02     LIKE ime_file.ime02
   DEFINE l_ime       RECORD LIKE ime_file.*

   IF cl_null(p_ime01) THEN RETURN END IF
   IF cl_null(p_ime02) THEN RETURN END IF
   SELECT * FROM ime_file WHERE ime01 = p_ime01 AND ime02 = p_ime02
   IF SQLCA.sqlcode = 100 THEN
      SELECT * INTO l_ime.* FROM ime_file WHERE ime01 = p_ime01 AND ime02 = ' '
      IF SQLCA.sqlcode THEN
         CALL cl_err(p_ime01,SQLCA.sqlcode,1)
         RETURN
      ELSE
         LET l_ime.ime02 = p_ime02
         LET l_ime.ime03 = p_ime02
         LET l_ime.imeacti = 'Y'  #FUN-D40103 add

         INSERT INTO ime_file VALUES(l_ime.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err('ins ime',SQLCA.sqlcode,1)
            RETURN
         END IF
      END IF
   END IF

END FUNCTION
#No.MOD-CB0199  --End

