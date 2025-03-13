# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_upimgg.4gl
# Descriptions...: 更新雙單位倉庫庫存明細檔
# Date & Author..: 05/04/20 By Carrier  FUN-540022 FUN-550130
# Usage..........: CALL s_upimgg(p_rowid,p_type,p_qty2,p_date,
#                                p_item,p_stock,p_locat,p_lot,p_no,p_line,
#                                p_unit,p_qty,p_unit2,p_fac1,p_fac2,p_fac3,
#                                p_act,p_proj,m_pri,s_pri,p_cla,p_ono,p_fac4)
# Input Parameter.dbo.p_rowid    imgg_file之rowid
#                 p_type     欲更新之方式
#                     +1   入庫
#                     0    報廢,倉庫退貨
#                     -1   出庫
#                     2    盤點
#                 p_qty2     庫存數量(庫存單位)
#                 p_date     異動日期
#                 p_item     料件
#                 p_stock    倉庫
#                 p_locat    儲位
#                 p_lot      批號
#                 p_no       單號
#                 p_line     項次
#                 p_unit     單位(採購/生產)
#                 p_qty      收貨數量(採購/生產單位)
#                 p_unit2    單位(庫存)
#                 p_fac1     庫存單位對採購單位換算率
#                 p_fac2     庫存單位對料件庫存單位換算率
#                 p_fac3     庫存單位對料件成本單位換算率
#                 p_act      倉儲會計科目
#                 p_proj     專案號碼
#                 m_pri      發料優先順序
#                 s_pri      銷售優先順序
#                 p_cla      庫存等級           
#                 p_ono      外觀代號           
#                 p_fac4     imgg09對img09的單位換算率
# Return Code....: NONE
# Modify.........: No.FUN-610057 06/01/13 By Carrier add axmt627/axmt628
# Modify.........: No.FUN-5C0114 06/01/19 By kim add asri210/220/230
# Modify.........: No.FUN-5C0114 06/02/15 By kim add asrt320
# Modify.........: No.FUN-610054 06/02/17 By wujie add atmt242/atmt260/atmt261/atmt252
# Modify.........: No.FUN-610070 06/02/19 alex add sub
# Modify.........: NO.TQC-620156 06/03/09 By kim GP3.0庫存不足err_log 延續 FUN-610070 的修改
# Modify.........: No.FUN-640053 06/04/09 By Sarah add atmt321
# Modify.........: No.MOD-660122 06/06/30 By Rayven 當ima25與img09的單位一樣時，imgg21及imgg211所存的轉換率，也應該要一樣
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0083 06/12/05 By Nicola 錯誤訊息彙整
# Modify.........: No.FUN-670012 07/02/05 By ching 行業別 add g_prog[1,7]
# Modify.........: No.CHI-710041 07/03/13 By jamie 取消sma882欄位及其判斷
# Modify.........: No.CHI-740011 07/04/13 By jamie 改CHI-710041判斷
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-830025 08/03/19 By kim GP5.1 整合測試修改
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimgg相關改以 料倉儲批為參數傳入 ,不使用 rowid 
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.FUN-AB0011 10/11/11 By huangtao mod 參數
# Modify.........: No.FUN-BC0036 11/12/16 By jason 新增ICD刻號/BIN調整單庫存判斷
# Modify.........: No:FUN-C70014 12/07/11 By wangwei 新增RUN CARD發料作業
# Modify.........: No:FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-CA0084 12/11/01 By xuxz axmt700走開票流程扣帳修改
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30054 13/03/21 By lixh1 FUN-D30024所做的修改在正式區被還原,故重新過單
# Modify.........: No:FUN-D40103 13/05/10 By lixh1 增加儲位有效性檢查 
# Modify.........: No:TQC-D40078 13/04/27 By fengrui 負庫存函数添加营运中心参数

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_upimgg(p_rowid,p_type ,p_qty2 ,p_date ,p_item ,  #FUN-8C0084
FUNCTION s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,#FUN-8C0084   #TQC-D30054
                  p_type ,p_qty2 ,p_date ,p_item ,
                  p_stock,p_locat,p_lot  ,p_no   ,p_line ,
                  p_unit ,p_qty  ,p_unit2,p_fac1 ,p_fac2 ,
                  p_fac3 ,p_act  ,p_proj ,m_pri  ,s_pri  ,
                  p_cla  ,p_ono  ,p_fac4)  #No.FUN-550130
DEFINE
    #No.TQC-9B0015  --Begin
    #p_rowid    LIKE type_file.chr18,
    p_rx       LIKE type_file.chr18,
    #No.TQC-9B0015  --End  
    p_type     LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    p_qty2     LIKE imgg_file.imgg10,
    p_date     LIKE imgg_file.imgg17, #異動日期
    p_item     LIKE imgg_file.imgg01,
    p_stock    LIKE imgg_file.imgg02,
    p_locat    LIKE imgg_file.imgg03,
    p_lot      LIKE imgg_file.imgg04,
    p_imgg01   LIKE imgg_file.imgg01,   #FUN-8C0084
    p_imgg02   LIKE imgg_file.imgg02,   #FUN-8C0084
    p_imgg03   LIKE imgg_file.imgg03,   #FUN-8C0084
    p_imgg04   LIKE imgg_file.imgg04,   #FUN-8C0084
    p_imgg09   LIKE imgg_file.imgg09,   #FUN-8C0084
    p_no       LIKE imgg_file.imgg05,
    p_line     LIKE imgg_file.imgg06,
    p_unit     LIKE imgg_file.imgg07,
    p_qty      LIKE imgg_file.imgg08,
    p_unit2    LIKE imgg_file.imgg09,
    p_fac1     LIKE imgg_file.imgg20,
    p_fac2     LIKE imgg_file.imgg21,
    p_fac3     LIKE imgg_file.imgg34,
    p_fac4     LIKE imgg_file.imgg211,   #No.FUN-550130
    p_act      LIKE imgg_file.imgg26,
    p_cla      LIKE imgg_file.imgg19,
    p_ono      LIKE imgg_file.imgg36,
    p_proj     LIKE imgg_file.imgg35,
    m_pri      LIKE imf_file.imf06,   #發料順序
    s_pri      LIKE imf_file.imf06,   #銷售領料順序
    l_date     LIKE imgg_file.imgg17, #異動日期
    l_ima71    LIKE ima_file.ima71,   #儲存有效天數
    l_imgg22   LIKE imgg_file.imgg22, #儲位類別
    l_imgg10_o LIKE imgg_file.imgg10, #
    l_imgg23   LIKE imgg_file.imgg23, #可用倉儲
    l_imgg24   LIKE imgg_file.imgg24, #mrp 可用倉儲
    l_imgg25   LIKE imgg_file.imgg25, #保稅否
    s_qty      LIKE imf_file.imf04,   #最高存量
    s_unit     LIKE imf_file.imf05,   #庫存單位
    l_ima906   LIKE ima_file.ima906,
    l_imgg00   LIKE imgg_file.imgg00,
    s_status   LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    l_sum1     LIKE imf_file.imf04, 	#No.FUN-680147 DEC(16,3)
    l_sum2     LIKE imf_file.imf04,     #No.FUN-680147 DEC(16,3)
    l_msg      LIKE zaa_file.zaa08,     #No:8652 #No.FUN-680147 VARCHAR(30)
    l_flag     LIKE type_file.chr1,     #是否控制庫存量不得為負(Y/N) 	#No.FUN-680147 VARCHAR(1)
    g_flag     LIKE type_file.chr1,     #FUN-C80107 add
    l_sw       LIKE type_file.num5,     #No.TQC-660122 	#No.FUN-680147 SMALLINT
    l_ima25    LIKE ima_file.ima25, #No.TQC-660122
    l_img09    LIKE img_file.img09  #No.TQC-660122
DEFINE l_n     LIKE type_file.num5  #FUN-8C0084
#FUN-A90049 -------------start------------------------------------   
 #   IF s_joint_venture( p_item ,g_plant) OR NOT s_internal_item( p_item,g_plant ) THEN                       #FUN-AB0011  mark
     IF s_joint_venture( p_imgg01 ,g_plant) OR NOT s_internal_item( p_imgg01,g_plant ) THEN                       #FUN-AB0011
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
 
     #No.FUN-8C0084--BEGIN--
     IF g_prog[1,7]= 'aimt337' THEN
        SELECT count(*) INTO l_n FROM imgg_file
        WHERE imgg01 = p_imgg01
          AND imgg02 = p_imgg02
          AND imgg03 = p_imgg03
          AND imgg04 = p_imgg04
          AND imgg09 = p_imgg09
    #No.TQC-9B0015  --Begin
       IF l_n <= 0 THEN
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
    IF g_sma.sma12 != 'Y' THEN
       RETURN
    END IF
 
    #檢查更新方式是否正確
    # add p_type = 0 for 報廢
    IF p_type != 1 AND p_type != -1 AND p_type != 0  AND p_type != 2
       THEN RETURN
    END IF
    
    #No.FUN-8C0084--BEGIN--
    IF cl_null(p_imgg01) THEN LET p_imgg01 = ' ' END IF
    IF cl_null(p_imgg02) THEN LET p_imgg02 = ' ' END IF
    IF cl_null(p_imgg03) THEN LET p_imgg03 = ' ' END IF
    IF cl_null(p_imgg04) THEN LET p_imgg04 = ' ' END IF
    IF cl_null(p_imgg09) THEN LET p_imgg09 = ' ' END IF
    #No.FUN-8C0084--END--
 
    SELECT imgg10 INTO l_imgg10_o FROM imgg_file
    #FUN-8C0084--BEGIN--
    #WHERE imgg01=p_item AND imgg02=p_stock AND imgg03=p_locat AND imgg04=p_lot AND imgg09=p_unit2
     WHERE imgg01=p_imgg01
       AND imgg02=p_imgg02
       AND imgg03=p_imgg03
       AND imgg04=p_imgg04
       AND imgg09=p_imgg09
    #No.FUN-8C0084--END--
 
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=p_item
    IF l_ima906 ='2' THEN LET l_imgg00='1' END IF
    IF l_ima906 ='3' THEN LET l_imgg00='2' END IF
 
    ####################################################################
    ## 依主程式代號加上參數sma894決定是否控制庫存量不可為負
    LET g_flag = NULL    #FUN-C80107 add 
    CASE 
         #(庫存不足是否許雜項發料及報廢)
         WHEN g_prog[1,7]='aimt301' OR g_prog[1,7]='aimt302' OR g_prog[1,7]='aimt303' OR 
              g_prog[1,7]='aimt311' OR g_prog[1,7]='aimt312' OR g_prog[1,7]='aimt313' OR
              g_prog='aimp379' OR g_prog='atmt260' OR g_prog='atmt261'    #No.FUN-610064 
             #IF g_sma.sma894[1,1]='N' THEN   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant) RETURNING g_flag            #FUN-D30024 add #TQC-D40078 g_plant
              IF g_flag = 'N' THEN  #FUN-C80107 add
                 LET l_flag = 'Y'
              END IF
 
         #(庫存不足是否允許出貨扣帳)
         WHEN g_prog[1,7]='axmt650' OR g_prog[1,7]='axmt610' OR g_prog[1,7]='axmt620'
           OR g_prog='atmt242' OR g_prog='axmp650'  #FUN-610064
           OR g_prog='axmt627' OR g_prog='axmt628'  #FUN-610057
           OR g_prog='axmp820' OR g_prog='axmp900' OR g_prog='axmp830'
           OR g_prog='axmp901' OR g_prog='axmp910' OR g_prog='axmp911' 
           OR g_prog[1,7]='axmt820' OR g_prog[1,7]='axmt821'  #MOD-530003  
           OR g_prog='atmt321'  #FUN-640053 add
             #IF g_sma.sma894[2,2]='N' THEN   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant) RETURNING g_flag            #FUN-D30024 add #TQC-D40078 g_plant
              IF g_flag = 'N' THEN  #FUN-C80107 add
                 LET l_flag = 'Y'
              END IF
 
         #(庫存不足是否允許工單發料退料過帳還原)
         WHEN g_prog[1,7]='asfi511' OR g_prog[1,7]='asfi512' OR g_prog[1,7]='asfi513' OR 
              g_prog[1,7]='asfi514' OR g_prog[1,7]='asfi526' OR g_prog[1,7]='asfi527' OR 
              g_prog[1,7]='asfi528' OR g_prog[1,7]='asfi529' OR g_prog[1,7]='asfi519' OR    #FUN-C70014 add g_prog[1,7]='asfi519'
              g_prog[1,7]='asfi510' OR g_prog[1,7]='asfi520' OR g_prog[1,7]='asri210' OR
              g_prog[1,7]='asri220' OR g_prog[1,7]='asri230'
             #IF g_sma.sma894[3,3]='N' THEN   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant) RETURNING g_flag            #FUN-D30024 add #TQC-D40078 g_plant
              IF g_flag = 'N' THEN  #FUN-C80107 add
                 LET l_flag = 'Y'
              END IF
              
         #(庫存不足是否允許調撥出庫)
         WHEN g_prog='aimp400' OR g_prog='aimp401' OR g_prog='aimp700' OR 
              g_prog='aimp701' OR g_prog[1,7]='aimt324' OR g_prog[1,7]='aimt325' OR
              g_prog='aimp378' OR g_prog[1,7]='aict324' #FUN-BC0036 add aict324
             #IF g_sma.sma894[4,4]='N' THEN   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant) RETURNING g_flag            #FUN-D30024 add #TQC-D40078 g_plant
              IF g_flag = 'N' THEN  #FUN-C80107 add
                 LET l_flag = 'Y'
              END IF
              
         #(庫存不足是否允許還料出庫)
         WHEN g_prog='aimt306' OR g_prog='aimt309'
             #IF g_sma.sma894[5,5]='N' THEN   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[5,5],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant) RETURNING g_flag            #FUN-D30024 add #TQC-D40078 g_plant
              IF g_flag = 'N' THEN  #FUN-C80107 add
                 LET l_flag = 'Y'
              END IF
              
         #(庫存不足是否允許採購退庫過帳及入庫過帳還原)
         WHEN g_prog[1,7]='apmt720' OR g_prog[1,7]='apmt721' OR g_prog[1,7]='apmt722' OR
              g_prog[1,7]='apmt730' OR g_prog[1,7]='apmt731' OR g_prog[1,7]='apmt732' OR
              g_prog[1,7]='apmt740' OR g_prog[1,7]='apmt732' OR
              g_prog[1,7]='asft620' OR g_prog[1,7]='asft622'            #No.B404 add
              OR g_prog[1,7]='asrt320'                             #FUN-5C0114
              OR g_prog[1,7]='apmt740' OR g_prog[1,7]='apmt741' OR g_prog[1,7]='apmt742' 
              OR g_prog[1,7]='asft700' OR g_prog='asft730' 
              OR g_prog[1,7]='aict042' OR g_prog[1,7]='aict043' OR  #CHI-830025
              g_prog[1,7]='aict044' #CHI-830025
 
             #IF g_sma.sma894[6,6]='N' THEN   #FUN-C80107 mark
	     #CALL s_inv_shrt_by_warehouse(g_sma.sma894[6,6],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant) RETURNING g_flag            #FUN-D30024 add #TQC-D40078 g_plant
              IF g_flag = 'N' THEN  #FUN-C80107 add
                 LET l_flag = 'Y'
              END IF
             
         #(庫存不足是否允許銷退過帳還原)
         WHEN g_prog[1,7]='axmt700' OR g_prog[1,7]='axmt840' OR g_prog='axmp750' OR
              g_prog='axmp870' OR g_prog='atmt252'    #No.FUN-610064
             #IF g_sma.sma894[7,7]='N' THEN   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[7,7],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant) RETURNING g_flag            #FUN-D30024 add #TQC-D40078 g_plant
              IF g_flag = 'N' THEN  #FUN-C80107 add
                 LET l_flag = 'Y'
              END IF
            
         #(是否允許盤點過帳後庫存為負)
         WHEN g_prog='aimp880' OR g_prog='aimt307' OR g_prog='aimp920'
             #IF g_sma.sma894[8,8]='N' THEN   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[8,8],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant) RETURNING g_flag            #FUN-D30024 add #TQC-D40078 g_plant
              IF g_flag = 'N' THEN  #FUN-C80107 add
                 LET l_flag = 'Y'
              END IF
           
         OTHERWISE
              LET l_flag = 'N'
    END CASE
    #################################################################
 
    CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
    LET l_msg=l_msg CLIPPED,',p_no,'-',p_line USING '##&'  #No:8652
    #TQC-620156...............begin
    IF cl_null(p_item) THEN
       SELECT imgg01 INTO p_item FROM imgg_file 
       #No.FUN-8C0084--BEGIN--
       #WHERE imgg01=p_item AND imgg02=p_stock AND imgg03=p_locat AND imgg04=p_lot AND imgg09=p_unit2
        WHERE imgg01=p_imgg01
          AND imgg02=p_imgg02
          AND imgg03=p_imgg03
          AND imgg04=p_imgg04
          AND imgg09=p_imgg09
       #No.FUN-8C0084--END--
    END IF
    #TQC-620156...............end
    #報廢時, 只要更新原有的, 就可以了 (david)
    IF p_type = 0 THEN  #報廢
       IF l_imgg10_o<p_qty2 AND p_qty2>0 AND l_flag = 'Y' THEN 
          #-----No.FUN-6C0083-----
          IF g_bgerr THEN
             CALL s_errmsg('ima01',p_item,l_msg,'aim-406',1)
          ELSE
             CALL cl_err(l_msg CLIPPED,'aim-406',1)
          END IF
          #-----No.FUN-6C0083 END-----
          LET g_success='N'
          RETURN  #No:8652
       END IF
 
       UPDATE imgg_file
          SET imgg10=imgg10-p_qty2,   #庫存數量
              imgg17=p_date           #異動日期
       #No.FUN-8C0084--BEGIN--
       #WHERE imgg01=p_item AND imgg02=p_stock AND imgg03=p_locat AND imgg04=p_lot AND imgg09=p_unit2
        WHERE imgg01=p_imgg01
          AND imgg02=p_imgg02
          AND imgg03=p_imgg03
          AND imgg04=p_imgg04
          AND imgg09=p_imgg09
       #No.FUN-8C0084--END--
       IF SQLCA.sqlcode   THEN
          LET g_success='N' 
          CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
          LET l_msg=l_msg CLIPPED,':ckp#1'
          #-----No.FUN-6C0083-----
          IF g_bgerr THEN
             CALL s_errmsg('ima01',p_item,l_msg,SQLCA.sqlcode,1)
          ELSE
            #CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)  #FUN-670091
             CALL cl_err3("upd","imgg_file","","",SQLCA.sqlcode,"",l_msg,1)  #FUN-670091
          END IF
          #-----No.FUN-6C0083 END-----
          RETURN
       END IF
       CALL chk_imgg10_0(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09)  #FUN-8C0084
       RETURN
    END IF
 
    #出庫時, 只要更新原有的, 就可以了
    IF p_type =-1 THEN  #出庫
      #IF l_imgg10_o < p_qty2 AND p_qty2 > 0 AND l_flag = 'Y' THEN #FUN-CA0084 mark
       IF l_imgg10_o < p_qty2 AND p_qty2 > 0 AND l_flag = 'Y' AND #FUN-CA0084 add
          NOT  (g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND g_aza.aza26 = '2' AND g_prog = 'axmt700') THEN#FUN-CA0084 add
          #-----No.FUN-6C0083-----
          IF g_bgerr THEN
             CALL s_errmsg('ima01',p_item,l_msg,'aim-406',1)
          ELSE
             CALL cl_err(l_msg,'aim-406',1)
          END IF
          #-----No.FUN-6C0083 END-----
          LET g_success='N'
          RETURN  #No:8652
       END IF
 
       UPDATE imgg_file
          SET imgg10=imgg10-p_qty2,    #庫存數量
              imgg16=p_date,           #最近發料日期
              imgg17=p_date            #異動日期
       #FUN-8C0084--BEGIN--
      #WHERE imgg01=p_item AND imgg02=p_stock AND imgg03=p_locat AND imgg04=p_lot AND imgg09=p_unit2
        WHERE imgg01=p_imgg01
          AND imgg02=p_imgg02
          AND imgg03=p_imgg03
          AND imgg04=p_imgg04
          AND imgg09=p_imgg09
       #No.FUN-8C0084--END--
       IF SQLCA.sqlcode THEN
          LET g_success='N' 
          CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
          LET l_msg=l_msg CLIPPED,':ckp#2'
          #-----No.FUN-6C0083-----
          IF g_bgerr THEN
             CALL s_errmsg('ima01',p_item,l_msg,SQLCA.sqlcode,1)
          ELSE
            #CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)  #FUN-670091
             CALL cl_err3("upd","imgg_file","","",SQLCA.sqlcode,"",l_msg,1)  #FUN-670091
          END IF
          #-----No.FUN-6C0083 END-----
          RETURN
       END IF
       CALL chk_imgg10_0(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09) #FUN-8C0084
       RETURN
    END IF
 
    #入庫時, 稍為麻煩點, 因為不確定該筆是否已經存在
    #No.TQC-9B0015 --Begin 
   #IF p_rowid!='-3333' THEN #原明細資料存在
    IF p_rx   !='-3333' THEN #原明細資料存在
    #No.TQC-9B0015 --End   
       IF (l_imgg10_o+p_qty2)<0 AND p_qty2<0 AND l_flag = 'Y' THEN 
          CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
          #-----No.FUN-6C0083-----
          IF g_bgerr THEN
             CALL s_errmsg('ima01',p_item,l_msg,'aim-406',1)
          ELSE
             CALL cl_err(l_msg,'aim-406',1)
          END IF
          #-----No.FUN-6C0083 END-----
          LET g_success='N'
          RETURN
       END IF
       IF p_type = 2 THEN                #盤點
          UPDATE imgg_file
             SET imgg10=imgg10+p_qty2,   #庫存數量 + 盤盈虧數量
                 imgg14=p_date,          #盤點日期
                 imgg17=p_date           #異動日期
          #FUN-8C0084--BEGIN--
          #WHERE imgg01=p_item AND imgg02=p_stock AND imgg03=p_locat AND imgg04=p_lot AND imgg09=p_unit2
           WHERE imgg01=p_imgg01
             AND imgg02=p_imgg02
             AND imgg03=p_imgg03
             AND imgg04=p_imgg04
             AND imgg09=p_imgg09
          #No.FUN-8C0084--END--
          IF SQLCA.sqlcode   THEN
             LET g_success='N' 
             CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
             LET l_msg=l_msg CLIPPED,':ckp#3'
             #-----No.FUN-6C0083-----
             IF g_bgerr THEN
                CALL s_errmsg('ima01',p_item,l_msg,SQLCA.sqlcode,1)
             ELSE
               #CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)  #FUN-670091
                CALL cl_err3("upd","imgg_file","","",SQLCA.sqlcode,"",l_msg,1) #FUN-670091
             END IF
             #-----No.FUN-6C0083 END-----
             RETURN
          END IF
       ELSE 
          UPDATE imgg_file
             SET imgg10=imgg10+p_qty2,   #庫存數量
                 imgg15=p_date,          #最近收料日期
                 imgg17=p_date           #異動日期
          #No.FUN-8C0084--BEGIN--
          #WHERE imgg01=p_item AND imgg02=p_stock AND imgg03=p_locat AND imgg04=p_lot AND imgg09=p_unit2
           WHERE imgg01=p_imgg01
             AND imgg02=p_imgg02
             AND imgg03=p_imgg03
             AND imgg04=p_imgg04
             AND imgg09=p_imgg09
          #No.FUN-8C0084--END--
          IF SQLCA.sqlcode   THEN
             LET g_success='N' 
             CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
             LET l_msg=l_msg CLIPPED,':ckp#4'
             #-----No.FUN-6C0083-----
             IF g_bgerr THEN
                CALL s_errmsg('ima01',p_item,l_msg,SQLCA.sqlcode,1)
             ELSE
               #CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)  #FUN-670091
                CALL cl_err3("upd","imgg_file","","",SQLCA.sqlcode,"",l_msg,1) #FUN-670091
             END IF
             #-----No.FUN-6C0083 END-----
             RETURN
           END IF
       END IF
       CALL chk_imgg10_0(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09) #FUN-8C0084
       RETURN
    END IF
 
#--->盤虧時, 不新增庫存明細
    IF p_type = 2 AND p_qty2 < 0 THEN
       RETURN
    END IF
 
    #取得該料件的儲存有效天數
    SELECT ima71 INTO l_ima71
      FROM ima_file
     WHERE ima01=p_item
    IF SQLCA.sqlcode OR l_ima71 IS NULL THEN
       LET l_ima71=0
    END IF
    IF l_ima71 =0 THEN
       LET l_date=g_lastdat
    ELSE
       LET l_date=DATE(p_date+l_ima71)
    END IF
 
    #取得儲位性質
    IF NOT cl_null(p_locat) THEN
       SELECT ime04,ime05,ime06,ime07
         INTO l_imgg22,l_imgg23,l_imgg24,l_imgg25
         FROM ime_file
        WHERE ime01=p_stock
          AND ime02=p_locat
          AND imeacti = 'Y'   #FUN-D40103
    ELSE
       SELECT imd10,imd11,imd12,imd13
         INTO l_imgg22,l_imgg23,l_imgg24,l_imgg25
         FROM imd_file
        WHERE imd01=p_stock
    END IF
 
    IF SQLCA.SQLCODE THEN
       LET l_imgg23='Y'
       LET l_imgg24='Y'
    END IF
 
    #No.TQC-660122 --start--
    SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=p_item                                                                   
    IF SQLCA.sqlcode OR cl_null(l_ima25) THEN                                                                                    
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_item,'sel ima',SQLCA.sqlcode,0)
       ELSE
         #CALL cl_err('sel ima',SQLCA.sqlcode,0)   #FUN-670091
          CALL cl_err3("sel","ima_file",p_item,"",SQLCA.sqlcode,"","",1)  #FUN-670091                                                                                   
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_success = 'N'
    END IF                                                                                                                       
    CALL s_umfchk(p_item,p_unit2,l_ima25)                                                                                         
         RETURNING l_sw,p_fac2                                                                                                 
    IF l_sw  = 1 THEN                                                                
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_item,'imgg09/ima25','mfg3075',0)
       ELSE
          CALL cl_err('imgg09/ima25','mfg3075',0)                                                                                   
       END IF
       #-----No.FUN-6C0083 END-----
       LET p_fac2 = 1
    END IF                                                                                                                       
    SELECT img09 INTO l_img09                                                                                                    
      FROM img_file                                                                                                              
     WHERE img01 = p_item  AND img02 = p_stock                                                                                    
       AND img03 = p_locat AND img04 = p_lot                                                                                      
    IF SQLCA.sqlcode OR cl_null(l_img09) THEN                                                                                    
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          LET g_showmsg=p_item CLIPPED,'/',p_stock CLIPPED,'/',p_locat CLIPPED,'/',p_lot CLIPPED
          CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'sel img',SQLCA.sqlcode,0)
       ELSE
         #CALL cl_err('sel img',SQLCA.sqlcode,0)   #FUN-670091
          CALL cl_err3("sel","img_file",p_item,"",SQLCA.sqlcode,"","",1) #FUN-670091                                                                                  
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_success = 'N'
    END IF                                                                                                                       
    CALL s_umfchk(p_item,p_unit2,l_img09)                                                                                         
         RETURNING l_sw,p_fac4                                                                                                
    IF l_sw = 1 THEN
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_item,'imgg09/ima25','mfg3075',0)
       ELSE
          CALL cl_err('imgg09/ima25','mfg3075',0)                                                                                   
       END IF
       #-----No.FUN-6C0083 END-----
       LET p_fac4 = 1
    END IF 
    #No.TQC-660122 --end--
 
    IF p_stock IS NULL THEN LET p_stock= ' ' END IF   #MOD-490056
    IF p_locat IS NULL THEN LET p_locat= ' ' END IF
    IF p_lot   IS NULL THEN LET p_lot=' '    END IF
    IF p_fac1  IS NULL THEN LET p_fac1=1     END IF
    IF p_fac2  IS NULL THEN LET p_fac2=1     END IF
    IF p_fac3  IS NULL THEN LET p_fac3=1     END IF
    IF p_fac4  IS NULL THEN LET p_fac4=1     END IF  #No.FUN-550130  
 
    CALL s_hqty(p_item,p_stock,p_locat) RETURNING s_status,s_qty,s_unit 
    IF s_qty IS NULL THEN
       LET s_qty=0
    END IF
 
        INSERT INTO imgg_file
#              1      2       3       4     5    6
        VALUES(l_imgg00,p_item,p_stock,p_locat,p_lot,p_no,p_line,
#       7      8     9       10     11 12 13        
        p_unit,p_qty,p_unit2,p_qty2, 0, 0, null, #NO:7522
#       14     15     16     17     18                    
        p_date,p_date,p_date,p_date,l_date,
#       19     20     21     22      23      24      25
        p_cla,p_fac1,p_fac2,l_imgg22,l_imgg23,l_imgg24,l_imgg25,
#       26    27   28     30 31 32 33, 34     35     36   37    211
        p_act,m_pri,s_pri, 0, 0, 0, 0, p_fac3,p_proj,p_ono,null,p_fac4, #No.FUN-550130
#       plant legal
        g_plant,g_legal)   #FUN-980012 add
 
 
        IF SQLCA.sqlcode THEN
           LET g_success='N' 
           CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
           LET l_msg=l_msg CLIPPED,':ckp#5'
           #-----No.FUN-6C0083-----
           IF g_bgerr THEN
              CALL s_errmsg('ima01',p_item,l_msg,SQLCA.sqlcode,1)
           ELSE
             #CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)  #FUN-670091
              CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"",l_msg,1)  #FUN-670091
           END IF
           #-----No.FUN-6C0083 END-----
           RETURN
        END IF
 
    #(@@)成本問題尚未解決
 
    #--------- 97/06/18 AIM 3.0 產品會議 : check 最高存量限制
    SELECT SUM(imgg10*imgg20) INTO l_sum1 FROM imgg_file
     WHERE imgg01=p_item AND imgg02=p_stock AND imgg03=p_locat
    IF STATUS OR l_sum1 IS NULL THEN
       LET l_sum1=0
    END IF
 
    SELECT imf04 INTO l_sum2 FROM imf_file
     WHERE imf01=p_item AND imf02=p_stock AND imf03=p_locat
    IF STATUS OR l_sum2 IS NULL THEN
       RETURN
    END IF
 
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
END FUNCTION
 
#FUNCTION chk_imgg10_0(l_rowid)#FUN-8C0084
FUNCTION chk_imgg10_0(l_imgg01,l_imgg02,l_imgg03,l_imgg04,l_imgg09) #FUN-8C0084
    DEFINE l_imgg10 LIKE imgg_file.imgg10
    #No.FUN-8C0084--BEGIN--
    DEFINE l_imgg01 LIKE imgg_file.imgg01
    DEFINE l_imgg02 LIKE imgg_file.imgg02
    DEFINE l_imgg03 LIKE imgg_file.imgg03
    DEFINE l_imgg04 LIKE imgg_file.imgg04
    DEFINE l_imgg09 LIKE imgg_file.imgg09
    #No.FUN-8C0084--END--
     
    #CHI-740011---mark---str---
    #IF g_sma.sma882='Y' THEN    #CHI-710041 mark
    #  SELECT imgg10 INTO l_imgg10 FROM imgg_file WHERE rowid=l_rowid
    #  IF l_imgg10=0 THEN 
    #     DELETE FROM imgg_file WHERE rowid=l_rowid
    #  END IF
    #END IF   
    #CHI-740011---mark---end---
END FUNCTION
 
