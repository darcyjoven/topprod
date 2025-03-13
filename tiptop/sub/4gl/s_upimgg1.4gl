# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_upimgg1.4gl
# Descriptions...: 更新雙單位倉庫庫存明細檔
# Date & Author..: 05/04/20 By Carrier  FUN-540022 FUN-550130
# Usage..........: CALL s_upimgg1(p_rowid,p_type,p_qty2,p_date,p_item,p_stock,
#                                 p_locat,p_lot,p_no,p_line,p_unit,p_qty,
#                                 p_unit2,p_fac1,p_fac2,p_fac3,p_act,p_proj,
#                                 m_pri,s_pri,p_cla,p_ono,p_fac4,p_dbs)   #FUN-5B0125
# Input Parameter: p_rowid   imgg_file之rowid
#                  p_type    欲更新之方式
#                     +1   入庫
#                     0    報廢,倉庫退貨
#                     -1   出庫
#                     2    盤點
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
#                  p_fac4    imgg09對img09的單位換算率
#                  p_dbs     資料庫編號   #FUN-5B0125
# Return code....: NONE
# Modify.........: No.FUN-5B0125 05/12/16 By Sarah 增加p_dbs參數,並將所有對資料
#                                                  庫的動作都改成透過prepare的方式
# Modify.........: No.FUN-5C0114 06/02/20 By kim add asri210/220/230/asrt320
# Modify.........: No.FUN-640053 06/04/09 By Sarah add atmt321,axmt628
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: NO.TQC-680007 06/08/02 BY wujie 修正ora下rowid的引用
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.CHI-710041 07/03/13 By jamie 取消sma882欄位及其判斷
# Modify.........: No.CHI-740011 07/04/13 By jamie 改CHI-710041判斷
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-830025 08/03/19 By kim GP5.1 整合測試修改
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimgg相關改以 料倉儲批為參數傳入 ,不使用 rowid 
# Modify.........: No.FUN-980012 09/08/25 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980094 09/09/10 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980020 09/09/28 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-A50102 10/06/30 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.FUN-AB0011 10/11/11 By huangtao mod 參數
# Modify.........: No:FUN-C70014 12/07/11 By wangwei 新增RUN CARD發料作業
# Modify.........: No:FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30054 13/03/21 By lixh1 FUN-D30024所做的修改在正式區被還原,故重新過單
# Modify.........: No:TQC-D40078 13/04/27 By fengrui 負庫存函数添加营运中心参数
# Modify.........: No:FUN-D40103 13/05/10 By lixh1 增加儲位有效性檢查
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_upimgg1(p_rowid,p_type ,p_qty2 ,p_date ,p_item ,  #FUN-8C0084
FUNCTION s_upimgg1(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,#FUN-8C0084
                   p_type ,p_qty2 ,p_date ,p_item ,   
                   p_stock,p_locat,p_lot  ,p_no   ,p_line ,
                   p_unit ,p_qty  ,p_unit2,p_fac1 ,p_fac2 ,
                   p_fac3 ,p_act  ,p_proj ,m_pri  ,s_pri  ,
                   p_cla  ,p_ono  ,p_fac4 #)  #No.FUN-550130    
                 #,p_dbs)     #FUN-5B0125 #FUN-980094 mark
                  ,p_plant)   #FUN-980094    #TQC-D30054 
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
    p_fac4     LIKE imgg_file.imgg211,#No.FUN-550130
    p_dbs      LIKE type_file.chr21,               #FUN-5B0125 	#No.FUN-680147 VARCHAR(21)
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
    l_sum1     LIKE imf_file.imf04,     #No.FUN-680147 DEC(16,3)
    l_sum2     LIKE imf_file.imf04,     #No.FUN-680147 DEC(16,3)
    l_msg      LIKE zaa_file.zaa08,    #No:8652 	#No.FUN-680147 VARCHAR(30)
    l_flag     LIKE type_file.chr1                  #是否控制庫存量不得為負(Y/N) 	#No.FUN-680147 VARCHAR(1)
   ,l_sql      STRING,                #FUN-5B0125
    l_z        LIKE imf_file.imf04,   #FUN-5B0125 	#No.FUN-680147 DEC(15,3)
    #No.TQC-660122 --start--
    l_ima25    LIKE ima_file.ima25,
    l_img09    LIKE img_file.img09,
    l_azp03    LIKE azp_file.azp03,
    l_sw       LIKE type_file.num5   	#No.FUN-680147 SMALLINT
    #No.TQC-660122 --end--
 
DEFINE p_plant    LIKE azp_file.azp01   #FUN-980094
DEFINE p_dbs_tra  LIKE type_file.chr21  #FUN-980094
DEFINE l_legal    LIKE azw_file.azw02   #FUN-980094
DEFINE g_flag     LIKE type_file.chr1   #FUN-C80107
#FUN-A90049 -------------start------------------------------------   
#    IF s_joint_venture( p_item ,p_plant) OR NOT s_internal_item( p_item,p_plant ) THEN                #FUN-AB0011  mark
     IF s_joint_venture( p_imgg01 ,p_plant) OR NOT s_internal_item( p_imgg01,p_plant ) THEN                #FUN-AB0011
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
 
   #FUN-980094 ------------------------------(S)
    LET g_plant_new = p_plant
 
    CALL s_getdbs()
    LET p_dbs = g_dbs_new
 
    CALL s_gettrandbs()
    LET p_dbs_tra = g_dbs_tra
   #FUN-980094 ------------------------------(E)
 
    #No.TQC-9B0015  --Begin
    #LET p_rowid = -9999  #FUN-8C0084
    LET p_rx = -9999  #FUN-8C0084
    #No.TQC-9B0015  --End  
    WHENEVER ERROR CALL cl_err_msg_log
    #單倉管理者, 在此不用麻煩了
    IF g_sma.sma12 != 'Y' THEN RETURN END IF
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
 
   #start FUN-5B0125
   #SELECT imgg10 INTO l_imgg10_o FROM imgg_file
   # WHERE rowid=p_rowid
   #LET l_sql = "SELECT imgg10 FROM ",p_dbs CLIPPED,"imgg_file ", #FUN-980094
    #LET l_sql = "SELECT imgg10 FROM ",p_dbs_tra CLIPPED,"imgg_file ", #FUN-980094
    LET l_sql = "SELECT imgg10 FROM ",cl_get_target_table(p_plant,'imgg_file'), #FUN-A50102
                #No.FUN-8C0084--BEGIN--
                #" WHERE rowid='",p_rowid CLIPPED,"'"    #No.TQC-680007
                " WHERE imgg01='",p_imgg01 ,"' ",
                "   AND imgg02='",p_imgg02 ,"' ",
                "   AND imgg03='",p_imgg03 ,"' ",
                "   AND imgg04='",p_imgg04 ,"' ", 
                "   AND imgg09='",p_imgg09 ,"' " 
                #No.FUN-8C0084--END--
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980094
 
    PREPARE imgg_c1 FROM l_sql
    DECLARE imgg_cur1 CURSOR FOR imgg_c1
    OPEN imgg_cur1
    FETCH imgg_cur1 INTO l_imgg10_o
    IF STATUS THEN
       #CALL cl_err('sel imgg_file',STATUS,1)   #FUN-670091
       CALL cl_err3("sel","imgg_file","","",STATUS,"","",1)  #FUN-670091
       LET g_success='N' RETURN
    END IF
 
   #SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=p_item
    #LET l_sql = "SELECT ima906 FROM ",p_dbs CLIPPED,"ima_file ",
    LET l_sql = "SELECT ima906 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                " WHERE ima01='",p_item,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE ima_c1 FROM l_sql
    DECLARE ima_cur1 CURSOR FOR ima_c1
    OPEN ima_cur1
    FETCH ima_cur1 INTO l_ima906
    IF STATUS THEN
       #CALL cl_err('sel ima_file',STATUS,1)  #FUN-670091
        CALL cl_err3("sel","ima_file","","",STATUS,"","",1) #FUN-670091
       LET g_success='N' RETURN
    END IF
   #end FUN-5B0125
    IF l_ima906 ='2' THEN LET l_imgg00='1' END IF
    IF l_ima906 ='3' THEN LET l_imgg00='2' END IF
 
    ####################################################################
    ## 依主程式代號加上參數sma894決定是否控制庫存量不可為負
    LET g_flag = NULL    #FUN-C80107 add 
    CASE 
         #(庫存不足是否許雜項發料及報廢)
         WHEN g_prog='aimt301' OR g_prog='aimt302' OR g_prog='aimt303' OR 
              g_prog='aimt311' OR g_prog='aimt312' OR g_prog='aimt313' OR
              g_prog='aimp379' 
             #IF g_sma.sma894[1,1]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant_new) RETURNING g_flag                    #FUN-D30024 add 
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
 
         #(庫存不足是否允許出貨扣帳)
         WHEN g_prog='axmt650' OR g_prog='axmt610' OR g_prog='axmt620'
              OR g_prog='axmp820' OR g_prog='axmp900' OR g_prog='axmp830'
              OR g_prog='axmp901' 
	      OR g_prog='axmp910' 
              OR g_prog='axmp911' 
              OR g_prog='axmt820'  OR g_prog='axmt821'   #MOD-530003  
              OR g_prog='atmt321' OR g_prog='axmt628'  #FUN-640053 add
             #IF g_sma.sma894[2,2]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant_new) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
 
         #(庫存不足是否允許工單發料退料過帳還原)
         WHEN g_prog='asfi511' OR g_prog='asfi512' OR g_prog='asfi513' OR 
              g_prog='asfi514' OR g_prog='asfi526' OR g_prog='asfi527' OR 
              g_prog='asfi528' OR g_prog='asfi529' OR g_prog='asfi519' OR        #FUN-C70014 add g_prog='asfi519'
              g_prog='asfi510' OR g_prog='asfi520' OR
              g_prog='asri210' OR g_prog='asri220' OR g_prog='asri230' #FUN-5C0114
             #IF g_sma.sma894[3,3]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant_new) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
              
         #(庫存不足是否允許調撥出庫)
         WHEN g_prog='aimp400' OR g_prog='aimp401' OR g_prog='aimp700' OR 
              g_prog='aimp701' OR g_prog='aimt324' OR g_prog='aimt325' OR
              g_prog='aimp378'
             #IF g_sma.sma894[4,4]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant_new) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
              
         #(庫存不足是否允許還料出庫)
         WHEN g_prog='aimt306' OR g_prog='aimt309'
             #IF g_sma.sma894[5,5]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
	     #CALL s_inv_shrt_by_warehouse(g_sma.sma894[5,5],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant_new) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
              
         #(庫存不足是否允許採購退庫過帳及入庫過帳還原)
         WHEN g_prog='apmt720' OR g_prog='apmt721' OR g_prog='apmt722' OR
              g_prog='apmt730' OR g_prog='apmt731' OR g_prog='apmt732' OR
              g_prog='apmt740' OR g_prog='apmt732' OR
              g_prog='asft620' OR g_prog='asft622'   #No.B404 add
              OR g_prog='apmt740'  OR g_prog='apmt741' OR g_prog='apmt742' 
              OR g_prog='asft700'  OR g_prog='asft730' OR g_prog='asrt320' #FUN-5C0114 add asrt320
              OR g_prog[1,7]='aict042' OR g_prog[1,7]='aict043' #CHI-830025
              OR g_prog[1,7]='aict044' #CHI-830025
 
             #IF g_sma.sma894[6,6]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[6,6],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant_new) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
             
         #(庫存不足是否允許銷退過帳還原)
         WHEN g_prog='axmt700' OR g_prog='axmt840' OR g_prog='axmp750' OR
              g_prog='axmp870' 
             #IF g_sma.sma894[7,7]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[7,7],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant_new) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
            
         #(是否允許盤點過帳後庫存為負)
         WHEN g_prog='aimp880' OR g_prog='aimt307' OR g_prog='aimp920'
             #IF g_sma.sma894[8,8]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[8,8],p_imgg02) RETURNING g_flag  #FUN-C80107 add #FUN-D30024
              CALL s_inv_shrt_by_warehouse(p_imgg02,g_plant_new) RETURNING g_flag                    #FUN-D30024 add
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 add
           
         OTHERWISE
              LET l_flag = 'N'
    END CASE
    #################################################################
    CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
    LET l_msg=l_msg CLIPPED,',p_no,'-',p_line USING '##&'  #No:8652
 
    #報廢時, 只要更新原有的, 就可以了 (david)
    IF p_type = 0 THEN  #報廢
       IF l_imgg10_o<p_qty2 AND p_qty2>0 AND l_flag = 'Y' THEN 
          CALL cl_err(l_msg CLIPPED,'aim-406',1) LET g_success='N' RETURN  #No:8652
       END IF
        #start FUN-5B0125
{ckp#1} #UPDATE imgg_file
        #   SET imgg10=imgg10-p_qty2, #庫存數量
        #       imgg17=p_date        #異動日期
        #   WHERE rowid=p_rowid
        #IF SQLCA.sqlcode   THEN
        #   LET g_success='N' 
        #   CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
        #   LET l_msg=l_msg CLIPPED,':ckp#1'
        #   CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #LET l_sql = "UPDATE ",p_dbs CLIPPED,"imgg_file ", #FUN-980094
         #LET l_sql = "UPDATE ",p_dbs_tra CLIPPED,"imgg_file ", #FUN-980094
         LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'imgg_file'), #FUN-A50102
                     "   SET imgg10=imgg10-",p_qty2,",",   #庫存數量
                     "       imgg17='",p_date,"'",         #異動日期
                     #No.FUN-8C0084--BEGIN--
                     #" WHERE rowid='",p_rowid CLIPPED,"'"          #No.TQC-680007
                     " WHERE imgg01='",p_imgg01 ,"' ",
                     "   AND imgg02='",p_imgg02 ,"' ",
                     "   AND imgg03='",p_imgg03 ,"' ",
                     "   AND imgg04='",p_imgg04 ,"' ", 
                     "   AND imgg09='",p_imgg09 ,"' " 
                     #No.FUN-8C0084--END--
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980094
         PREPARE imgg_upd1 FROM l_sql
         EXECUTE imgg_upd1
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success='N'
            CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
            LET l_msg=l_msg CLIPPED,':ckp#1'
            #CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)  #FUN-670091
            CALL cl_err3("upd","imgg_file","","",SQLCA.sqlcode,"",l_msg,1)  #FUN-670091
            RETURN
         END IF
        #end FUN-5B0125
        #FUN-980094----------(S)
        #CALL chk_imgg10_1(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_dbs) #FUN-8C0084
         CALL chk_imgg10_1(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_plant)
        #FUN-980094----------(E)
         RETURN
    END IF
 
    #出庫時, 只要更新原有的, 就可以了
    IF p_type =-1 THEN  #出庫
       IF l_imgg10_o<p_qty2 AND p_qty2>0 AND l_flag = 'Y' THEN 
           CALL cl_err(l_msg,'aim-406',1) LET g_success='N' RETURN  #No:8652
       END IF
        #start FUN-5B0125
{ckp#2} #UPDATE imgg_file
        #   SET imgg10=imgg10-p_qty2, #庫存數量
        #       imgg16=p_date,       #最近發料日期
        #       imgg17=p_date        #異動日期
        # WHERE rowid=p_rowid
        #IF SQLCA.sqlcode   THEN
        #   LET g_success='N' 
        #   CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
        #   LET l_msg=l_msg CLIPPED,':ckp#2'
        #   CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #LET l_sql = "UPDATE ",p_dbs CLIPPED,"imgg_file ", #FUN-980094
         #LET l_sql = "UPDATE ",p_dbs_tra CLIPPED,"imgg_file ", #FUN-980094
         LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'imgg_file'), #FUN-A50102
                     "   SET imgg10=imgg10-",p_qty2,",",   #庫存數量
                     "       imgg16='",p_date,"',",        #最近發料日期
                     "       imgg17='",p_date,"'",         #異動日期
                    #No.FUN-8C0084--BEGIN--
                    #" WHERE rowid='",p_rowid CLIPPED,"'"          #No.TQC-680007
                     " WHERE imgg01='",p_imgg01 ,"' ",
                     "   AND imgg02='",p_imgg02 ,"' ",
                     "   AND imgg03='",p_imgg03 ,"' ",
                     "   AND imgg04='",p_imgg04 ,"' ", 
                     "   AND imgg09='",p_imgg09 ,"' " 
                     #No.FUN-8C0084--END--
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980094
         PREPARE imgg_upd2 FROM l_sql
         EXECUTE imgg_upd2
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success='N'
            CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
            LET l_msg=l_msg CLIPPED,':ckp#2'
            #CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)  #FUN-670091
             CALL cl_err3("upd","imgg_file","","",SQLCA.sqlcode,"",l_msg,1)  #FUN-670091
            RETURN
         END IF
        #end FUN-5B0125
        #FUN-980094-------------(S)
        #CALL chk_imgg10_1(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_dbs)  #FUN-8C0084
         CALL chk_imgg10_1(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_plant)
        #FUN-980094-------------(E)
         RETURN
    END IF
    #入庫時, 稍為麻煩點, 因為不確定該筆是否已經存在
    #No.TQC-9B0015  --Begin
    #IF p_rowid!='-3333' THEN #原明細資料存在
    IF p_rx!='-3333' THEN #原明細資料存在
    #No.TQC-9B0015  --End  
       IF (l_imgg10_o+p_qty2)<0 AND p_qty2<0 AND l_flag = 'Y' THEN 
           CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
           CALL cl_err(l_msg CLIPPED,'aim-406',1) LET g_success='N' RETURN
       END IF
       IF p_type = 2 THEN  #盤點
          #start FUN-5B0125
{ckp#3}   #UPDATE imgg_file
          #    SET imgg10=imgg10+p_qty2, #庫存數量 + 盤盈虧數量
          #        imgg14=p_date,       #盤點日期
          #        imgg17=p_date        #異動日期
          #    WHERE rowid=p_rowid
          #IF SQLCA.sqlcode   THEN
          #   LET g_success='N' 
          #   CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
          #   LET l_msg=l_msg CLIPPED,':ckp#3'
          #   CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)
          #   RETURN
          #END IF
          #LET l_sql = "UPDATE ",p_dbs CLIPPED,"imgg_file ", #FUN-980094
           #LET l_sql = "UPDATE ",p_dbs_tra CLIPPED,"imgg_file ", #FUN-980094
           LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'imgg_file'), #FUN-A50102
                       "   SET imgg10=imgg10+",p_qty2,",",   #庫存數量 + 盤盈虧數量
                       "       imgg14='",p_date,"',",        #盤點日期
                       "       imgg17='",p_date,"'",         #異動日期
                       #No.FUN-8C0084--BEGIN--
                       #" WHERE rowid='",p_rowid CLIPPED,"'"         #No.TQC-680007
                       " WHERE imgg01='",p_imgg01 ,"' ",
                       "   AND imgg02='",p_imgg02 ,"' ",
                       "   AND imgg03='",p_imgg03 ,"' ",
                       "   AND imgg04='",p_imgg04 ,"' ", 
                       "   AND imgg09='",p_imgg09 ,"' " 
                      #No.FUN-8C0084--END--
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980094
           PREPARE imgg_upd3 FROM l_sql
           EXECUTE imgg_upd3
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
              LET g_success='N'
              CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
              LET l_msg=l_msg CLIPPED,':ckp#3'
              #CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)  #FUN-670091
              CALL cl_err3("upd","imgg_file","","",SQLCA.sqlcode,"",l_msg,1)  #FUN-670091
              RETURN
           END IF
          #end FUN-5B0125
       ELSE 
          #start FUN-5B0125
{ckp#4}   #UPDATE imgg_file
          #    SET imgg10=imgg10+p_qty2, #庫存數量
          #        imgg15=p_date,        #最近收料日期
          #        imgg17=p_date         #異動日期
          #    WHERE rowid=p_rowid
          #IF SQLCA.sqlcode   THEN
          #   LET g_success='N' 
          #   CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
          #   LET l_msg=l_msg CLIPPED,':ckp#4'
          #   CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)
          #   RETURN
          #END IF
          #LET l_sql = "UPDATE ",p_dbs CLIPPED,"imgg_file ", #FUN-980094
           #LET l_sql = "UPDATE ",p_dbs_tra CLIPPED,"imgg_file ", #FUN-980094
           LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'imgg_file'), #FUN-A50102
                       "   SET imgg10=imgg10+",p_qty2,",",   #庫存數量 + 盤盈虧數量
                       "       imgg15='",p_date,"',",        #最近收料日期
                       "       imgg17='",p_date,"'",         #異動日期
                       #No.FUN-8C0084--BEGIN--
                       #" WHERE rowid='",p_rowid CLIPPED,"'"          #No.TQC-680007
                       " WHERE imgg01='",p_imgg01 ,"' ",
                       "   AND imgg02='",p_imgg02 ,"' ",
                       "   AND imgg03='",p_imgg03 ,"' ",
                       "   AND imgg04='",p_imgg04 ,"' ", 
                       "   AND imgg09='",p_imgg09 ,"' " 
                      #No.FUN-8C0084--END--
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980094
           PREPARE imgg_upd4 FROM l_sql
           EXECUTE imgg_upd4
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
              LET g_success='N'
              CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
              LET l_msg=l_msg CLIPPED,':ckp#4'
              #CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)  #FUN-670091
               CALL cl_err3("upd","imgg_file","","",SQLCA.sqlcode,"",l_msg,1)  #FUN-670091
              RETURN
           END IF
          #end FUN-5B0125
       END IF
      #FUN-980094-------------(S)
      #CALL chk_imgg10_1(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_dbs) #FUN-8C0084
       CALL chk_imgg10_1(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_plant)
      #FUN-980094-------------(E)
       RETURN
    END IF
#--->盤虧時, 不新增庫存明細
    IF p_type = 2 AND p_qty2 < 0  THEN RETURN END IF
    #取得該料件的儲存有效天數
   #start FUN-5B0125
   #SELECT ima71 INTO l_ima71
   #    FROM ima_file
   #    WHERE ima01=p_item
   #IF SQLCA.sqlcode OR l_ima71 IS NULL THEN
   #    LET l_ima71=0
   #END IF
    #LET l_sql = "SELECT ima71 FROM ",p_dbs CLIPPED,"ima_file ",
    LET l_sql = "SELECT ima71 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                " WHERE ima01='",p_item,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE ima_c2 FROM l_sql
    DECLARE ima_cur2 CURSOR FOR ima_c2
    OPEN ima_cur2
    FETCH ima_cur2 INTO l_ima71
   #end FUN-5B0125
    IF STATUS OR l_ima71 IS NULL THEN
       LET l_ima71=0
    END IF
    IF l_ima71 =0 THEN LET l_date=g_lastdat
                  ELSE LET l_date=DATE(p_date+l_ima71)
    END IF
    #取得儲位性質
    IF NOT cl_null(p_locat) THEN
      #start FUN-5B0125
      #SELECT ime04,ime05,ime06,ime07
      #  INTO l_imgg22,l_imgg23,l_imgg24,l_imgg25
      #  FROM ime_file
      # WHERE ime01=p_stock AND
      #       ime02=p_locat
       LET l_sql = "SELECT ime04,ime05,ime06,ime07 ",
                   #"  FROM ",p_dbs CLIPPED,"ime_file ",
                   "  FROM ",cl_get_target_table(p_plant,'ime_file'), #FUN-A50102
                   " WHERE ime01='",p_stock,"'",
                   "   AND ime02='",p_locat,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
       PREPARE ime_c1 FROM l_sql
       DECLARE ime_cur1 CURSOR FOR ime_c1
       OPEN ime_cur1
       FETCH ime_cur1 INTO l_imgg22,l_imgg23,l_imgg24,l_imgg25
      #end FUN-5B0125
    ELSE
      #start FUN-5B0125
      #SELECT imd10,imd11,imd12,imd13
      #  INTO l_imgg22,l_imgg23,l_imgg24,l_imgg25
      #  FROM imd_file
      # WHERE imd01=p_stock
       LET l_sql = "SELECT imd10,imd11,imd12,imd13 ",
                   #"  FROM ",p_dbs CLIPPED,"imd_file ",
                   "  FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
                   " WHERE imd01='",p_stock,"'", 
                   "   AND imeacti = 'Y' "    #FUN-D40103
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
       PREPARE imd_c1 FROM l_sql
       DECLARE imd_cur1 CURSOR FOR imd_c1
       OPEN imd_cur1
       FETCH imd_cur1 INTO l_imgg22,l_imgg23,l_imgg24,l_imgg25
      #end FUN-5B0125
    END IF
    IF SQLCA.SQLCODE THEN LET l_imgg23='Y' LET l_imgg24='Y' END IF
 
    #No.TQC-660122 --start--
    #LET l_sql="SELECT ima25 FROM ",p_dbs CLIPPED,"ima_file",
LET l_sql="SELECT ima25 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102 
              " WHERE ima01='",p_item,"'"                                                                                        
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE s_ima_pre1 FROM l_sql                                                                                                
    DECLARE s_ima_cur1  CURSOR FOR s_ima_pre1                                                                                    
    OPEN s_ima_cur1                                                                                                              
    FETCH s_ima_cur1 INTO l_ima25                                                                                                
    IF SQLCA.sqlcode OR cl_null(l_ima25) THEN                                                                                    
       #CALL cl_err('sel ima',SQLCA.sqlcode,1)   #FUN-670091
       CALL cl_err3("sel","ima_file","","",SQLCA.sqlcode,"","",1)  #FUN-670091                                                                                  
       LET g_success = 'N'
    END IF                                                                                                                       
   #FUN-980094-------------(S)
   #LET l_azp03 = s_madd_img_catstr(p_dbs)                                                                                     
   #CALL s_umfchk1(p_item,p_unit2,l_ima25,l_azp03)                                                                                
    CALL s_umfchk1(p_item,p_unit2,l_ima25,p_plant)
   #FUN-980094-------------(E)
         RETURNING l_sw,p_fac2                                                                                                 
    IF l_sw  = 1 THEN                                                               
       CALL cl_err('imgg09/ima25','mfg3075',1)                                                                                   
       LET p_fac2 = 1
    END IF                                                                                                                       
   #LET l_sql="SELECT img09 FROM ",p_dbs CLIPPED,"img_file",     #FUN-980094
    #LET l_sql="SELECT img09 FROM ",p_dbs_tra CLIPPED,"img_file",     #FUN-980094
    LET l_sql="SELECT img09 FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102 
              " WHERE img01='",p_item,"'",                                                                                          
              "   AND img02='",p_stock,"'",                                                                                          
              "   AND img03='",p_locat,"'",                                                                                           
              "   AND img04='",p_lot,"'"                                                                                            
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980094
    PREPARE s_img_pre1 FROM l_sql                                                                                                   
    DECLARE s_img_cur1  CURSOR FOR s_img_pre1                                                                                       
    OPEN s_img_cur1                                                                                                                 
    FETCH s_img_cur1 INTO l_img09                                                                                                   
    IF SQLCA.sqlcode OR cl_null(l_img09) THEN                                                                                       
       #CALL cl_err('sel img',SQLCA.sqlcode,1)   #FUN-670091
        CALL cl_err3("sel","img_file","","",SQLCA.sqlcode,"","",1)  #FUN-670091                                                                                     
       LET g_success = 'N'
    END IF                                                                                                                          
   #CALL s_umfchk1(p_item,p_unit2,l_img09,l_azp03)     #FUN-980020  mark 
    CALL s_umfchk1(p_item,p_unit2,l_img09,p_plant)     #FUN-980020
         RETURNING l_sw,p_fac4                                                                                                   
    IF l_sw  = 1 THEN                                                                  
       CALL cl_err('imgg09/img09','mfg3075',1)                                                                                      
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
    IF s_qty IS NULL THEN LET s_qty=0 END IF
       #start FUN-5B0125
{ckp#5}#INSERT INTO imgg_file
#      #       1        2      3       4       5     6    7
       #VALUES(l_imgg00,p_item,p_stock,p_locat,p_lot,p_no,p_line,
#      #8      9     10      11     12 13  14        
       #p_unit,p_qty,p_unit2,p_qty2, 0, 0, null, #NO:7522
#      #15     16     17     18     19
       #p_date,p_date,p_date,p_date,l_date,
#      #20    21     22     23       24       25       26
       #p_cla,p_fac1,p_fac2,l_imgg22,l_imgg23,l_imgg24,l_imgg25,
#      #27    28    29    30 31 32 33, 34     35     36   37    38
       #p_act,m_pri,s_pri, 0, 0, 0, 0, p_fac3,p_proj,p_ono,null,p_fac4) #No.FUN-550130
       #LET l_sql = "INSERT INTO ",p_dbs CLIPPED,"imgg_file", #FUN-980094
        #LET l_sql = "INSERT INTO ",p_dbs_tra CLIPPED,"imgg_file", #FUN-980094
        LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant,'imgg_file'), #FUN-A50102 
                    " VALUES(?,?,?,?,?,?,?,?,?,?,",
                    "        ?,?,?,?,?,?,?,?,?,?,",
                    "        ?,?,?,?,?,?,?,?,?,?,",
                    "        ?,?,?,?,?,?,?,?,",
                    "        ?,?) "   #FUN-980012 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE imgg_ins FROM l_sql
        IF SQLCA.sqlcode THEN
           CALL cl_err('prepare:',SQLCA.sqlcode,1)
           LET g_success = "N"
           RETURN
        END IF
        LET l_z = 0
        CALL s_getlegal(p_plant) RETURNING l_legal #FUN-980012 add
        EXECUTE imgg_ins USING l_imgg00,p_item,p_stock,p_locat,p_lot,p_no,
                               p_line,p_unit,p_qty,p_unit2,p_qty2,l_z,l_z,'',
                               p_date,p_date,p_date,p_date,l_date,p_cla,p_fac1,
                               p_fac2,l_imgg22,l_imgg23,l_imgg24,l_imgg25,
                               p_act,m_pri,s_pri,l_z,l_z,l_z,l_z,p_fac3,p_proj,
                               p_ono,'',p_fac4,
                               p_plant,l_legal   #FUN-980012 add
       #end FUN-5B0125
        IF SQLCA.sqlcode THEN
           LET g_success='N' 
           CALL cl_getmsg('asm-321',g_lang) RETURNING l_msg
           LET l_msg=l_msg CLIPPED,':ckp#5'
           #CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)  #FUN-670091
            CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"",l_msg,1)  #FUN-670091
           RETURN
        END IF
 
    #(@@)成本問題尚未解決
 
    #--------- 97/06/18 AIM 3.0 產品會議 : check 最高存量限制
   #start FUN-5B0125
   #SELECT SUM(imgg10*imgg20) INTO l_sum1 FROM imgg_file
   # WHERE imgg01=p_item AND imgg02=p_stock AND imgg03=p_locat
   #LET l_sql = "SELECT SUM(imgg10*imgg20) FROM ",p_dbs CLIPPED,"imgg_file ", #FUN-980094
    #LET l_sql = "SELECT SUM(imgg10*imgg20) FROM ",p_dbs_tra CLIPPED,"imgg_file ", #FUN-980094
    LET l_sql = "SELECT SUM(imgg10*imgg20) FROM ",cl_get_target_table(p_plant,'imgg_file'), #FUN-A50102 
                " WHERE imgg01='",p_item,"'",
                "   AND imgg02='",p_stock,"'",
                "   AND imgg03='",p_locat,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980094
    PREPARE imgg_c2 FROM l_sql
    DECLARE imgg_cur2 CURSOR FOR imgg_c2
    OPEN imgg_cur2
    FETCH imgg_cur2 INTO l_sum1
   #end FUN-5B0125
    IF STATUS OR l_sum1 IS NULL THEN LET l_sum1=0 END IF
   #start FUN-5B0125
   #SELECT imf04 INTO l_sum2 FROM imf_file
   # WHERE imf01=p_item AND imf02=p_stock AND imf03=p_locat
    #LET l_sql = "SELECT imf04 FROM ",p_dbs CLIPPED,"imf_file ",
    LET l_sql = "SELECT imf04 FROM ",cl_get_target_table(p_plant,'imf_file'), #FUN-A50102 
                " WHERE imf01='",p_item,"'",
                "   AND imf02='",p_stock,"'",
                "   AND imf03='",p_locat,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE imgg_c3 FROM l_sql
    DECLARE imgg_cur3 CURSOR FOR imgg_c3
    OPEN imgg_cur3
    FETCH imgg_cur3 INTO l_sum2
   #end FUN-5B0125
    IF STATUS OR l_sum2 IS NULL THEN RETURN END IF
    IF l_sum1>l_sum2 THEN
       LET g_success='N' 
       CALL cl_err('(ckp#6) ','aim-390',1)
       RETURN
    END IF 
    #-----------------------------------
END FUNCTION
 
#FUNCTION chk_imgg10_1(p_dbs) #FUN-8C0084
#FUN-980094-------------(S)
#FUNCTION chk_imgg10_1(l_imgg01,l_imgg02,l_imgg03,l_imgg04,l_imgg09,p_dbs)  #FUN-8C0084
FUNCTION chk_imgg10_1(l_imgg01,l_imgg02,l_imgg03,l_imgg04,l_imgg09,p_plant)
#FUN-980094-------------(E)
    DEFINE l_imgg10 LIKE imgg_file.imgg10
    DEFINE l_sql   STRING      #FUN-5B0125
    DEFINE p_dbs   LIKE type_file.chr21     #FUN-5B0125 	#No.FUN-680147 VARCHAR(21)
 
    DEFINE p_dbs_tra   LIKE type_file.chr21 #FUN-980094
    DEFINE p_plant     LIKE azp_file.azp01  #FUN-980094
 
    #No.FUN-8C0084--BEGIN--
    DEFINE l_imgg01  LIKE imgg_file.imgg01  
    DEFINE l_imgg02  LIKE imgg_file.imgg02  
    DEFINE l_imgg03  LIKE imgg_file.imgg03  
    DEFINE l_imgg04  LIKE imgg_file.imgg04  
    DEFINE l_imgg09  LIKE imgg_file.imgg09
    #No.FUN-8C0084--END--  
 
   #FUN-980094 ------------------------------(S)
    LET g_plant_new = p_plant
 
    CALL s_getdbs()
    LET p_dbs = g_dbs_new
 
    CALL s_gettrandbs()
    LET p_dbs_tra = g_dbs_tra
   #FUN-980094 ------------------------------(E)
 
 
    #CHI-740011---mark---str--- 
    #IF g_sma.sma882='Y' THEN   #CHI-710041 mark
    # #start FUN-5B0125
    # #SELECT imgg10 INTO l_imgg10 FROM imgg_file WHERE rowid=l_rowid
    #  LET l_sql = "SELECT imgg10 FROM ",p_dbs CLIPPED,"imgg_file ",
    #              " WHERE rowid='",l_rowid CLIPPED,"'"
    #  PREPARE imgg_c4 FROM l_sql
    #  DECLARE imgg_cur4 CURSOR FOR imgg_c4
    #  OPEN imgg_cur4
    #  FETCH imgg_cur4 INTO l_imgg10
    # #end FUN-5B0125
    #  IF l_imgg10=0 THEN 
    #    #start FUN-5B0125
    #    #DELETE FROM imgg_file WHERE rowid=l_rowid
    #     LET l_sql = "DELETE FROM ",p_dbs," WHERE rowid='",l_rowid CLIPPED,"'"
    #     PREPARE delimgg_pre FROM l_sql
    #     IF SQLCA.sqlcode THEN
    #        #CALL cl_err(l_rowid,SQLCA.sqlcode,0)  #FUN-670091
    #         CALL cl_err3("del","imgg_file","","",SQLCA.sqlcode,"","",0)  #FUN-670091
    #        RETURN
    #     END IF
    #     EXECUTE delimgg_pre
    #     IF SQLCA.sqlcode THEN
    #        #CALL cl_err(l_rowid,SQLCA.sqlcode,0)  #FUN-670091
    #        CALL cl_err3("del","imgg_file","","",SQLCA.sqlcode,"","",0)  #FUN-670091
    #        RETURN
    #     ELSE
    #         IF SQLCA.SQLERRD[3] != 0 THEN
    #            #CALL cl_err(l_rowid,'mfg1023',0)  #FUN-670091
    #            CALL cl_err3("del","imgg_file","","",SQLCA.sqlcode,"",'mfg1023',0)  #FUN-670091
    #         END IF
    #     END IF
    #    #end FUN-5B0125
    #  END IF
    #END IF   
    #CHI-740011---mark---end--- 
END FUNCTION
