# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_upimg1.4gl
# Descriptions...: 更新倉庫庫存明細檔
# Date & Author..: 92/05/23 By Pin
# Usage..........: CALL s_upimg1(p_rowid,p_type,p_qty2,p_date,p_item,p_stock,
#                                p_locat,p_lot,p_no,p_line,p_unit,p_qty,p_unit2,
#                                p_fac1,p_fac2,p_fac3,p_act,p_proj,m_pri,s_pri,
#                                p_cla,p_ono,p_dbs)
# Input Parameter: p_rowid   img_file之rowid
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
#                  p_dbs     資料庫名稱
# Return code....: NONE
# Modify.........: 92/06/02 By David for 報廢
# Modify.........: 92/11/17 By Jones For Multiplant
#                  本副程式和原副程式差別在於(多加了p_dbs:Server Name的參數)
#                  並且所有並資料庫的動作都需透過 prepare 的方式來作
# Modify.........: No.MOD-560296 05/06/30 By Carrier insert img_file SQL錯誤
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 rowid 
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun img_file增加字段img38
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980094 09/09/15 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-9A0099 09/10/29 By TSD.apple    GP5.2架構重整g_plant 改成 p_plant  
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
# Modify.........: No.TQC-9C0099 09/12/16 By jan 修正s_hqty1的參數
# Modify.........: No:MOD-A20008 10/02/01 By sherry aimt720增加參數sma894的判斷
# Modify.........: No.FUN-A50102 10/06/30 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.FUN-AB0011 10/11/11 By huangtao 修改參數
# Modify.........: No:TQC-BB0038 11/11/09 By destiny artt256增加參數sma894的判斷
# Modify.........: No:FUN-C80107 12/09/17 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30054 13/03/21 By lixh1 FUN-D30024所做的修改在正式區被還原,故重新過單
# Modify.........: No:CHI-D10014 13/04/03 By bart 增加rvbs處理
# Modify.........: No:FUN-D40103 13/05/10 By lixh1 增加儲位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_upimg1(p_rowid,p_type,p_qty2,p_date, #FUN-8C0084
FUNCTION s_upimg1(p_img01,p_img02,p_img03,p_img04,p_type,p_qty2,p_date,  #FUN-8C0084   #TQC-D30054
    p_item,p_stock,p_locat,p_lot,p_no,p_line,
    p_unit,p_qty,p_unit2,p_fac1,p_fac2,p_fac3,
   #p_act,p_proj,m_pri,s_pri,p_cla,p_ono,p_dbs)
    p_act,p_proj,m_pri,s_pri,p_cla,p_ono,p_plant)
DEFINE
   #p_rowid LIKE type_file.chr18,       #No.TQC-9B0015
    p_rx    LIKE type_file.chr18,       #No.TQC-9B0015
    p_type LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    p_qty2  LIKE img_file.img10,
    p_date LIKE img_file.img17, #異動日期
    p_item  LIKE img_file.img01,
    p_stock LIKE img_file.img02,
    p_locat LIKE img_file.img03,
    p_lot   LIKE img_file.img04,
    p_img01 LIKE img_file.img01,  #FUN-8C0084
    p_img02 LIKE img_file.img02,  #FUN-8C0084
    p_img03 LIKE img_file.img03,  #FUN-8C0084
    p_img04 LIKE img_file.img04,  #FUN-8C0084
    p_no    LIKE img_file.img05,
    p_line  LIKE img_file.img06,
    p_unit  LIKE img_file.img07,
    p_qty   LIKE img_file.img08,
    p_unit2 LIKE img_file.img09,
    p_fac1 LIKE img_file.img20,
    p_fac2 LIKE img_file.img21,
    p_fac3 LIKE img_file.img34,
    p_act  LIKE img_file.img26,
    p_cla  LIKE img_file.img19,
    p_ono  LIKE img_file.img36,
    p_dbs  LIKE type_file.chr21,              #工廠編號 	#No.FUN-680147 VARCHAR(21)
    p_dbs_tra  LIKE type_file.chr21,          #FUN-980094
    p_proj LIKE img_file.img35,
    m_pri   LIKE imf_file.imf06, #發料順序
    s_pri   LIKE imf_file.imf06, #銷售領料順序
    l_date LIKE img_file.img17, #異動日期
    l_ima71 LIKE ima_file.ima71, #儲存有效天數
    l_img22 LIKE img_file.img22, #儲位類別
    l_img23 LIKE img_file.img23, #可用倉儲
    l_img24 LIKE img_file.img24, #mrp 可用倉儲
    l_img25 LIKE img_file.img25, #保稅否
    s_qty   LIKE imf_file.imf04, #最高存量
    s_unit  LIKE imf_file.imf05, #庫存單位
    l_sql   LIKE type_file.chr1000,    	#No.FUN-680147 VARCHAR(1000)
     #No.MOD-560296  --begin
    l_tmp    LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(01)
    s_status LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    l_i,l_j  LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    t_dbs    LIKE azp_file.azp01
     #No.MOD-560296  --end
DEFINE   p_plant        LIKE type_file.chr20  #FUN-980094
DEFINE l_img10    LIKE img_file.img10   #MOD-A20008
DEFINE l_flag     LIKE type_file.chr1   #MOD-A20008
DEFINE l_flag1    LIKE type_file.chr1   #FUN-C80107 add
#FUN-A90049 -------------start------------------------------------   
 #   IF s_joint_venture( p_item ,p_plant) OR NOT s_internal_item( p_item,p_plant ) THEN                 #FUN-AB0011   mark
     IF s_joint_venture( p_img01 ,p_plant) OR NOT s_internal_item( p_img01,p_plant ) THEN                 #FUN-AB0011
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED
   CALL s_getdbs()
   LET p_dbs = g_dbs_new     #將 g_dbs_new 的值給 p_dbs,這樣後續的語法就都不用改
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET p_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
 
    #No.TQC-9B0015  --Begin
    #LET p_rowid = -9999   #FUN-8C0084
    LET p_rx = -9999 
    #No.TQC-9B0015  --End  
    WHENEVER ERROR CALL cl_err_msg_log
    #單倉管理者, 在此不用麻煩了
    IF g_sma.sma12 != 'Y' THEN RETURN END IF
    #檢查更新方式是否正確
    # add p_type = 0 for 報廢
    IF p_type != 1 AND p_type != -1 AND p_type != 0  AND p_type != 2
       THEN RETURN
    END IF
    IF p_qty2 IS NULL THEN  
       LET p_qty2=0
    END IF
    #FUN-8C0084--BEGIN--
    IF cl_null(p_img01) THEN LET p_img01 = ' ' END IF
    IF cl_null(p_img02) THEN LET p_img02 = ' ' END IF
    IF cl_null(p_img03) THEN LET p_img03 = ' ' END IF
    IF cl_null(p_img04) THEN LET p_img04 = ' ' END IF
    #FUN-8C0084--END-- 
    #MOD-A20008---Begin
    IF g_prog[1,7] = 'aimt720' THEN
      #IF g_sma.sma894[4,4]='N' THEN  #FUN-C80107 mark
       LET l_flag1 = NULL    #FUN-C80107 add
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],p_img02) RETURNING l_flag1  #FUN-C80107 add #FUN-D30024
       CALL s_inv_shrt_by_warehouse(p_img02,g_plant_new) RETURNING l_flag1                    #FUN-D30024 add
       IF l_flag1 = 'N' THEN    #FUN-C80107 add
          LET l_flag='Y'
       END IF
    END IF
    #FUN-C80107 modify begin---------------------------   121101
    #SELECT img10 INTO l_img10 FROM img_file
    # WHERE img01=p_img01
    #   AND img02=p_img02
    #   AND img03=p_img03
    #   AND img04=p_img04
    LET l_sql = "SELECT img10 FROM ",cl_get_target_table(g_plant_new,'img_file'),
                " WHERE img01='",p_img01,"'",
                "   AND img02='",p_img02,"'",
                "   AND img03='",p_img03,"'",
                "   AND img04='",p_img04,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
    PREPARE sel_img FROM l_sql
    EXECUTE sel_img INTO l_img10
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL cl_err3("sel img10","img_file","","",SQLCA.sqlcode,"","s_upimg1:ckp#1",1)
       RETURN
    END IF
    #FUN-C80107 modify end-----------------------------
    #MOD-A20008---End
    #TQC-BB0038---Begin
    IF g_prog[1,7] = 'artt256' THEN
      #IF g_sma.sma894[4,4]='N' THEN  #FUN-C80107 mark
       LET l_flag1 = NULL    #FUN-C80107 add
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],p_img02) RETURNING l_flag1  #FUN-C80107 add
       CALL s_inv_shrt_by_warehouse(p_img02,g_plant_new) RETURNING l_flag1                    #FUN-D30024 add
       IF l_flag1 = 'N' THEN   #FUN-C80107 add
          LET l_flag='Y'
       END IF
    END IF
    #TQC-BB0038---End
    #報廢時, 只要更新原有的, 就可以了 (david)
    IF p_type = 0 THEN  #報廢
       #MOD-A20008---Begin
       IF l_img10 < p_qty2 AND p_qty2 > 0 AND l_flag = 'Y' THEN
          LET g_success='N'
          CALL cl_err3("upd","img_file","","","aim-406","","s_upimg1:ckp#1",1) #FUN-670091
          RETURN
       END IF
       #MOD-A20008---End
#{ckp#1 }LET l_sql = "UPDATE ",p_dbs CLIPPED,"img_file",
{ckp#1 }#LET l_sql = "UPDATE ",p_dbs_tra CLIPPED,"img_file",  #FUN-980094
        LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                    " SET img10=img10-",p_qty2, #庫存數量
                    " , img17 = '",p_date,"' ",    #異動日期
                  #No.FUN-8C0084--BEGIN--
                  # " WHERE rowid='",p_rowid CLIPPED,"'"   
                    " WHERE img01='",p_img01,"' ",
                    "   AND img02='",p_img02,"' ",
                    "   AND img03='",p_img03,"' ",
                    "   AND img04='",p_img04,"' "
                 #No.FUN-8C0084--END--
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   	   PREPARE img_u1 FROM l_sql
#          DECLARE img_up1 CURSOR FOR img_u1        
       EXECUTE img_u1 
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          LET g_success='N' 
          #CALL cl_err('(s_upimg1:ckp#1)',SQLCA.sqlcode,1) #FUN-670091
          CALL cl_err3("upd","img_file","","",SQLCA.sqlcode,"","s_upimg1:ckp#1",1) #FUN-670091
          RETURN
       END IF
       RETURN
    END IF
 
    #出庫時, 只要更新原有的, 就可以了
    IF p_type =-1 THEN  #出庫
       #MOD-A20008---Begin
       IF l_img10 < p_qty2 AND p_qty2 > 0 AND l_flag = 'Y' THEN
          LET g_success='N'
          CALL cl_err3("upd","img_file","","","asf-375","","s_upimg1:ckp#1",1) #FUN-670091
          RETURN
       END IF
       #MOD-A20008---End
#{ckp#2} LET l_sql = "UPDATE ",p_dbs CLIPPED,"img_file",
{ckp#2} #LET l_sql = "UPDATE ",p_dbs_tra CLIPPED,"img_file",  #FUN-980094
        LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                    " SET img10=img10-",p_qty2, #庫存數量
                    " , img16='",p_date,"' ",      #最近發料日期
                    " , img17='",p_date,"' ",       #異動日期
                   #No.FUN-8C0084--BEGIN--
                   #" WHERE rowid='",p_rowid CLIPPED,"'"
                    " WHERE img01='",p_img01,"' ",
                    "   AND img02='",p_img02,"' ",
                    "   AND img03='",p_img03,"' ",
                    "   AND img04='",p_img04,"' "
                 #No.FUN-8C0084--END--
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   	   PREPARE img_u2 FROM l_sql
#          DECLARE img_up2 CURSOR FOR img_u2        
        EXECUTE img_u2 
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           LET g_success='N' 
           #CALL cl_err('(s_upimg1:ckp#3)',SQLCA.sqlcode,1)  #FUN-670091
           CALL cl_err3("upd","img_file","","",SQLCA.sqlcode,"","s_upimg1:ckp#2",1)  #FUN-670091
           RETURN
        END IF
        CALL s_upimg1_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2) #CHI-D10014
        RETURN
    END IF
    #入庫時, 稍為麻煩點, 因為不確定該筆是否已經存在
    #No.TQC-9B0015  --Begin
    #IF p_rowid!='-3333' THEN #原明細資料存在
    IF p_rx!='-3333' THEN #原明細資料存在
    #No.TQC-9B0015  --End  
       #MOD-A20008---Begin
       IF (l_img10 + p_qty2)<0 AND p_qty2 < 0 AND l_flag = 'Y' THEN
          LET g_success='N'
          CALL cl_err3("upd","img_file","","","aim-406","","s_upimg1:ckp#1",1) #FUN-670091
          RETURN
       END IF
       #MOD-A20008---End
       IF p_type = 2 THEN  #盤點
#{ckp#3}   LET l_sql="UPDATE ",p_dbs CLIPPED,"img_file",
{ckp#3}   #LET l_sql="UPDATE ",p_dbs_tra CLIPPED,"img_file",   #FUN-980094
          LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                    " SET img10=img10+",p_qty2, #庫存數量 + 盤盈虧數量
                    " , img14='",p_date,"' ",       #盤點日期
                    " , img17='",p_date,"' ",       #異動日期
                   #No.FUN-8C0084--BEGIN--
                   #" WHERE rowid='",p_rowid CLIPPED,"'"
                    " WHERE img01='",p_img01,"' ",
                    "   AND img02='",p_img02,"' ",
                    "   AND img03='",p_img03,"' ",
                    "   AND img04='",p_img04,"' "
                 #No.FUN-8C0084--END--
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   	      PREPARE img_u3 FROM l_sql
#             DECLARE img_up3 CURSOR FOR img_u3        
          EXECUTE img_u3 
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
             LET g_success='N' 
             #CALL cl_err('(s_upimg1:ckp#3)',SQLCA.sqlcode,1)  #FUN-670091
             CALL cl_err3("upd","img_file","","",SQLCA.sqlcode,"","s_upimg1:ckp#3",1) #FUN-670091
             RETURN
          END IF
       ELSE 
#{ckp#4}   LET l_sql="UPDATE ",p_dbs CLIPPED,"img_file",
{ckp#4}   #LET l_sql="UPDATE ",p_dbs_tra CLIPPED,"img_file",  #FUN-980094
          LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                    " SET img10=img10+",p_qty2, #庫存數量
                    " , img15='",p_date,"' ",      #最近收料日期
                    " , img17='",p_date,"' ",      #異動日期
                   #No.FUN-8C0084--BEGIN--
                   #" WHERE rowid='",p_rowid CLIPPED,"'"
                    " WHERE img01='",p_img01,"' ",
                    "   AND img02='",p_img02,"' ",
                    "   AND img03='",p_img03,"' ",
                    "   AND img04='",p_img04,"' "
                 #No.FUN-8C0084--END--
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   	      PREPARE img_u4 FROM l_sql
#             DECLARE img_up4 CURSOR FOR img_u4        
          EXECUTE img_u4 
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
             LET g_success='N' 
             #CALL cl_err('(s_upimg1:ckp#4)',SQLCA.sqlcode,1)  #FUN-670091
              CALL cl_err3("upd","img_file","","",SQLCA.sqlcode,"","s_upimg1:ckp#4",1) #FUN-670091
             RETURN
          END IF
       END IF
       RETURN
    END IF
    IF p_type = 2 AND p_qty2 < 0  THEN RETURN END IF
    #取得該料件的儲存有效天數
    #LET l_sql = "SELECT ima71 FROM ",p_dbs CLIPPED,"ima_file",
    LET l_sql = "SELECT ima71 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                " WHERE ima01='",p_item,"'" CLIPPED
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE ima_71r FROM l_sql
    DECLARE ima_71 CURSOR FOR ima_71r      
    FOREACH ima_71 INTO l_ima71
       IF SQLCA.sqlcode OR l_ima71 IS NULL THEN
          LET l_ima71=0
       END IF
    END FOREACH
    IF l_ima71 =0 THEN LET  l_date=g_lastdat
                  ELSE LET l_date=DATE(p_date+l_ima71)
    END IF
    #取得儲位性質
    IF p_locat IS NOT NULL THEN
       #LET l_sql = " SELECT ime04,ime05,ime06,ime07 FROM ",p_dbs CLIPPED,  
       #            "ime_file",
       LET l_sql = " SELECT ime04,ime05,ime06,ime07 FROM ",cl_get_target_table(p_plant,'ime_file'), #FUN-A50102
                   " WHERE ime01 = '",p_stock,"' ",
                   " AND ime02 = '",p_locat,"' " CLIPPED,
                   " AND imeacti = 'Y' "   #FUN-D40103
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
       PREPARE ime_01r FROM l_sql
       DECLARE ime_01  CURSOR FOR ime_01r       
       FOREACH ime_01 INTO l_img22,l_img23,l_img24,l_img25 END FOREACH
    ELSE
       #LET l_sql = " SELECT imd10,imd11,imd12,imd13 FROM ",p_dbs CLIPPED,
       #            "imd_file",
       LET l_sql = " SELECT imd10,imd11,imd12,imd13 FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
                   " WHERE imd01 = '",p_stock,"'" CLIPPED
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
       PREPARE imd_01r FROM l_sql
       DECLARE imd_01 CURSOR FOR imd_01r       
       FOREACH imd_01 INTO l_img22,l_img23,l_img24,l_img25 END FOREACH
    END IF
    IF p_stock IS NULL THEN LET p_lot= ' ' END IF
    IF p_locat IS NULL THEN LET p_locat= ' ' END IF
    IF p_lot IS NULL THEN LET p_lot=' ' END IF
     #No.MOD-560296  --begin                                                     
    IF s_qty IS NULL THEN LET s_qty=0 END IF                                    
    LET l_j=length(p_dbs)                                                       
     FOR l_i=1 TO l_j                                                           
         LET l_tmp=p_dbs[l_i,l_i]                                               
         IF l_tmp != ":" THEN                                                   
            LET t_dbs=t_dbs CLIPPED,p_dbs[l_i,l_i]                              
         END IF                                                                 
     END FOR
   #CALL s_hqty1(p_item,p_stock,p_locat,p_dbs) RETURNING s_status,s_qty,s_unit 
   #CALL s_hqty1(p_item,p_stock,p_locat,t_dbs) RETURNING s_status,s_qty,s_unit  #TQC-9C0099
    CALL s_hqty1(p_item,p_stock,p_locat,p_plant) RETURNING s_status,s_qty,s_unit #TQC-9C0099
    IF s_qty IS NULL THEN LET s_qty=0 END IF
    #LET l_sql = "INSERT INTO ",p_dbs CLIPPED,"img_file",                       
     #LET l_sql = "INSERT INTO ",p_dbs_tra CLIPPED,"img_file",  #FUN-980094
     LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102    
                 " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?)" #No.TQC-930155   #FUN-980012
#                " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" #No.TQC-930155-mark
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
     PREPARE img_in1 FROM l_sql                                                 
#                          1      2       3       4     5    6      7           
     EXECUTE img_in1 USING p_item,p_stock,p_locat,p_lot,p_no,p_line,p_unit,     
#                          8     9       10     11  12  13   14     15          
                           p_qty,p_unit2,p_qty2,'0','0',''  ,p_date,p_date,     
#                          16     17     18     19    20     21     22          
                           p_date,p_date,l_date,p_cla,p_fac1,p_fac2,l_img22,    
#                          23      24      25      26    27     28              
                           l_img23,l_img24,l_img25,p_act,m_pri,s_pri,           
#                          30  31  32  33  34     35     36                     
                           '0','0','0','0',p_fac3,p_proj,p_ono,'','', #No.TQC-930155
#                          plant   legal    
                           p_plant,g_legal   #FUN-980012 add  #FUN-9A0099
#                          '0','0','0','0',p_fac3,p_proj,p_ono,''     #No.TQC-930155-mark
#    LET l_sql = "INSERT INTO ",p_dbs CLIPPED,"img_file",
#{ckp#5}         " VALUES('",p_item,"',","'",p_stock,"',","'",p_locat,"',",
#                "'",p_lot,"',","'",p_no,"',",p_line CLIPPED,",'",p_unit,"',",
#                p_qty CLIPPED,",'",p_unit2,"',",
#                p_qty2 CLIPPED,",",0,",",0,",",0,",",
#                "'',","'",p_date,"',","'',","'",p_date,"',","'",l_date,"',",
#                "'",p_cla,"',",p_fac1 CLIPPED,",",
#                p_fac2 CLIPPED,",'",l_img22,"',",
#                "'",l_img23,"',","'",l_img24,"',","'",l_img25,"',",
#                "'",p_act,"',",
#                m_pri CLIPPED,",",s_pri CLIPPED,",",0,",",0,",",0,",",
#                0,",",p_fac3 CLIPPED,",",
#                "'",p_proj,"',","'",p_ono,"'",")" CLIPPED
#    PREPARE img_in1 FROM l_sql
##   DECLARE img_in CURSOR FOR img_in1       
#    EXECUTE img_in1
# {ckp#5} INSERT INTO img_file
#              1      2       3       4     5    6
#       VALUES(p_item,p_stock,p_locat,p_lot,p_no,p_line,
#       7      8     9       10     11 12 13        
#       p_unit,p_qty,p_unit2,p_qty2, 0, 0, 0,
#       14 15     16 17     18                    
#       '',p_date,'',p_date,l_date,
#       19     20     21     22      23      24      25
#       p_cla,p_fac1,p_fac2,l_img22,l_img23,l_img24,l_img25,
#       26    27   28     30 31 32 33 34     35     36
#       p_act,m_pri,s_pri, 0, 0, 0, 0,p_fac3,p_proj,p_ono)
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
       LET g_success='N' 
       #CALL cl_err('(s_upimg1:ckp#5)',SQLCA.sqlcode,1)  #FUN-670091
       CALL cl_err3("ins","img_file","","",SQLCA.sqlcode,"","s_upimg1:ckp#5",1)  #FUN-670091
       RETURN
    END IF
#(@@)成本問題尚未解決
END FUNCTION
#CHI-D10014---begin
FUNCTION s_upimg1_imgs(p_img01,p_img02,p_img03,p_img04,p_type,p_no,p_line,p_unit2) 
   DEFINE p_type     LIKE type_file.num5,
          p_no       LIKE img_file.img05,
          p_line     LIKE img_file.img06,
          p_unit2    LIKE img_file.img09, 
          p_img01    LIKE img_file.img01, 
          p_img02    LIKE img_file.img02, 
          p_img03    LIKE img_file.img03, 
          p_img04    LIKE img_file.img04
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
   DEFINE l_ogb17    LIKE ogb_file.ogb17   
   DEFINE l_ogc18    LIKE ogc_file.ogc18   
   DEFINE l_cnt      LIKE type_file.num5   
   DEFINE l_imd10    LIKE imd_file.imd10  
   DEFINE l_imgs     RECORD LIKE imgs_file.*   
   DEFINE l_cnt1     LIKE type_file.num5   
   DEFINE l_no       LIKE img_file.img05   
   DEFINE l_oga011   LIKE oga_file.oga011  
   DEFINE l_oga65    LIKE oga_file.oga65  

   IF g_success = "N" THEN
      RETURN
   END IF
 
   IF g_prog[1,7]<> 'aimp701' THEN 
      RETURN
   END IF

   LET l_sql="SELECT img01,img02,img03,img04,img09 FROM ",cl_get_target_table(g_plant_new,'img_file'), 
                    " WHERE img01='",p_img01,"'",
                    "   AND img02='",p_img02,"'",
                    "   AND img03='",p_img03,"'",
                    "   AND img04='",p_img04,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE imgs_p1 FROM l_sql
   EXECUTE imgs_p1 INTO l_img01,l_img02,l_img03,l_img04,l_img09

   IF l_img02 IS NULL THEN LET l_img02= ' ' END IF 
   IF l_img03 IS NULL THEN LET l_img03= ' ' END IF
   IF l_img04 IS NULL THEN LET l_img04= ' ' END IF

   LET l_sql="SELECT ima918,ima921 FROM ",cl_get_target_table(g_plant_new,'ima_file'), 
                    " WHERE ima01='",l_img01,"'",
                    "   AND imaacti = 'Y' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE imgs_p2 FROM l_sql
   EXECUTE imgs_p2 INTO l_ima918,l_ima921
   
   IF cl_null(l_ima918) THEN
      LET l_ima918='N'
   END IF
                                                                                
   IF cl_null(l_ima921) THEN
      LET l_ima921='N'
   END IF
 
   IF l_ima918 = "N" AND l_ima921 = "N" THEN
      RETURN
   END IF
                                                         
   IF p_type = -1 OR p_type = 0 THEN
      LET l_rvbs09 = -1
   END IF
                                                                                
   IF p_type = 1 OR p_type = 2 THEN
      LET l_rvbs09 = 1
   END IF

   LET l_sql="SELECT imgs08 FROM ",cl_get_target_table(g_plant_new,'imgs_file'), 
             " WHERE imgs01=? ",
             "   AND imgs02=? ",
             "   AND imgs03=? ",
             "   AND imgs04=? ",
             "   AND imgs05=? ",
             "   AND imgs06=? ",
             "   AND imgs11=? "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE imgs_p3 FROM l_sql

   LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'imgs_file'), 
             "   SET imgs08=? ",
             " WHERE imgs01=? ",
             "   AND imgs02=? ",
             "   AND imgs03=? ",
             "   AND imgs04=? ",
             "   AND imgs05=? ",
             "   AND imgs06=? ",
             "   AND imgs11=? "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE imgs_p4 FROM l_sql

   LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'imgs_file'), 
             "   SET imgs08=? ",
             "       imgs09=? ",
             " WHERE imgs01=? ",
             "   AND imgs02=? ",
             "   AND imgs03=? ",
             "   AND imgs04=? ",
             "   AND imgs05=? ",
             "   AND imgs06=? ",
             "   AND imgs11=? "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE imgs_p5 FROM l_sql

   LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'imgs_file'),   
               " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?)" 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE imgs_in1 FROM l_sql  
   
   LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'rvbs_file'), 
                    " WHERE rvbs00 = '",g_prog,"'",
                    "   AND rvbs01 = '",p_no,"'", 
                    "   AND rvbs02 = ",p_line,
                    "   AND rvbs09 = ",l_rvbs09
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE rvbs_pre FROM l_sql
   DECLARE rvbs_cs CURSOR FOR rvbs_pre
 
   IF p_type = -1 OR p_type = 0 THEN
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

         EXECUTE imgs_p3 USING l_img01,l_img02,l_img03,l_img04,l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs08 INTO l_imgs08 
      
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

         IF l_imgs08 < 0 THEN    
            LET g_success='N'
            IF g_bgerr THEN
               CALL s_errmsg('ima01',l_img01,'imgs_file','asf-375',1)
            ELSE
               CALL cl_err('imgs_file','asf-375',1)
            END IF
            RETURN
         END IF
 
         EXECUTE imgs_p4 USING l_imgs08,l_img01,l_img02,l_img03,l_img04,l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs08
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
         EXECUTE imgs_p3 USING l_img01,l_img02,l_img03,l_img04,l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs08 INTO l_imgs08 
      
         IF STATUS = 100 THEN

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
            LET l_imgs.imgsplant = g_plant  
            LET l_imgs.imgslegal = g_legal  

            EXECUTE imgs_in1 USING l_imgs.*
            
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

         EXECUTE imgs_p5 USING l_imgs08,l_rvbs.rvbs05,l_img01,l_img02,l_img03,l_img04,l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs08
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
 
END FUNCTION
#CHI-D10014---end
