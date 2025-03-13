# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_mupimgg.4gl
# Descriptions...: 多角貿易更新imgg (可指定資料庫)
# Date & Author..: No.FUN-560043 05/07/13 By Smapmin 
# Usage..........: CALL s_mupimgg(p_type,p_part,p_ware,p_loca,p_lot,p_unit,p_qty,p_date,p_dbs)
# Input Parameter: p_type       +1 入庫 -1 出庫
#                  p_part       料件 
#                  p_ware       倉庫
#                  p_loca       儲位
#                  p_lot        批號
#                  p_unit       單位
#                  p_qty        異動數量
#                  p_date       異動日期 
#                  p_dbs        資料庫
# Return code....: 
# Modify.........: No.FUN-610057 06/01/13 By Carrier add axmt627/axmt628
# Modify.........: No.FUN-5C0114 06/02/20 By kim add asri210/220/230/asrt320
# Modify.........: No.FUN-640053 06/04/09 By Sarah add atmt321
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-720003 07/02/04 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-670012 07/02/05 By ching 行業別 add g_prog[1,7]
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-830025 08/03/19 By kim GP5.1 整合測試修改
# Modify.........: No.FUN-980094 09/09/15 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No:FUN-C80107 12/09/17 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30044 13/03/19 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30054 13/03/21 By lixh1 FUN-D30024所做的修改在正式區被還原,故重新過單
# Modify.........: No:TQC-D40078 13/04/27 By fengrui 負庫存函數添加營運中心參數
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680147 VARCHAR(72)
DEFINE   g_flag          LIKE type_file.chr1    #FUN-C80107 add
 
#FUN-980094 傳入的db變數應該成傳入plant 變數---------------------(S)
#FUNCTION s_mupimgg(p_type,p_part,p_ware,p_loca,p_lot,p_unit,p_qty,p_date,p_dbs) 
FUNCTION s_mupimgg(p_type,p_part,p_ware,p_loca,p_lot,p_unit,p_qty,p_date,p_plant) #TQC-D30054
#FUN-980094 傳入的db變數應該成傳入plant 變數---------------------(E)
  DEFINE l_sql     LIKE type_file.chr1000      #No.FUN-680147 VARCHAR(600)
  #DEFINE g_sma894  LIKE sma_file.sma894       #No.TQC-D30044 mark
  DEFINE l_imgg10   LIKE imgg_file.imgg10
  DEFINE p_type    LIKE type_file.num5         #No.FUN-680147 SMALLINT
  DEFINE p_part    LIKE imgg_file.imgg01,      ##料號
         p_ware    LIKE imgg_file.imgg02,      ##倉庫
         p_loca    LIKE imgg_file.imgg03,      ##儲位 
         p_lot     LIKE imgg_file.imgg04,      ##批號
         p_unit    LIKE imgg_file.imgg09,      ##單位 
         p_qty     LIKE imgg_file.imgg10,      #No.FUN-680147 DECIMAL (11,3)  ##數量
         p_date    LIKE type_file.dat,         #No.FUN-680147 DATE ##異動日期
         p_dbs     LIKE type_file.chr21,       #No.FUN-680147 VARCHAR(21)
         p_dbs_tra LIKE type_file.chr21,        #FUN-980094 
         l_flag    LIKE type_file.chr1         #是否控制庫存量不得為負(Y/N)        #No.FUN-680147 VARCHAR(1)
  DEFINE   p_plant        LIKE type_file.chr20  #FUN-980094
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_part ,p_plant) OR NOT s_internal_item( p_part,p_plant ) THEN
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
 
    IF p_part[1,4]='MISC' THEN RETURN END IF 
 
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED
   CALL s_getdbs()
   LET p_dbs = g_dbs_new     #將 g_dbs_new 的值給 p_dbs,這樣後續的語法就都不用改
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET p_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
    MESSAGE p_dbs CLIPPED,"u_imgg!"
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
   
#TQC-D30044--mark--str--
#    #LET l_sql = "SELECT sma894 FROM ",p_dbs CLIPPED, "sma_file",
#    LET l_sql = "SELECT sma894 FROM ",cl_get_target_table(g_plant_new,'sma_file'), #FUN-A50102
#                " WHERE sma00 = '0' "
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
#    PREPARE sma_pre FROM l_sql
#    DECLARE sma_cs CURSOR FOR sma_pre
#    OPEN sma_cs
#    FETCH sma_cs INTO g_sma894  
#    IF SQLCA.sqlcode THEN
#       LET g_msg = p_dbs CLIPPED,"sel sma894"
##      CALL cl_err(g_msg,'aoo-000',1)
##No.FUN-720003--begin                                                                                                               
#      IF g_bgerr THEN                                                                                                               
#         CALL s_errmsg('sma00','0',g_msg,'aoo-000',1)                                                                     
#      ELSE                                                                                                                          
#         CALL cl_err(g_msg,'aoo-000',1)                                                                             
#      END IF                                                                                                                        
##No.FUN-720003--end 
#       LET g_success = 'N'
#       RETURN
#    END IF
#TQC-D30044--mark--end--
 
    # 同 s_upimgg處理
    ####################################################################
    # 依主程式代號加上參數sma894決定是否控制庫存量不可為負
    # g_sma.sma894-->g_sma894
    LET g_flag = NULL    #FUN-C80107 add
    CASE 
         #(庫存不足是否許雜項發料及報廢)
         WHEN g_prog[1,7]='aimt301' OR g_prog[1,7]='aimt302' OR g_prog[1,7]='aimt303' OR 
              g_prog[1,7]='aimt311' OR g_prog[1,7]='aimt312' OR g_prog[1,7]='aimt313' OR
              g_prog='aimp379' 
             #IF g_sma894[1,1]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[1,1],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new 
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 add
 
         #(庫存不足是否允許出貨扣帳)
         WHEN g_prog[1,7]='axmt650' OR g_prog[1,7]='axmt610' OR g_prog[1,7]='axmt620'
              OR g_prog='axmt627' OR g_prog='axmt628'  #No.FUN-610057
              OR g_prog='axmp820' OR g_prog='axmp900' OR g_prog='axmp830'
              OR g_prog='axmp901' 
	      OR g_prog='axmp910' OR g_prog='axmp911'
              OR g_prog='atmt321'   #FUN-640053 add 
             #IF g_sma894[2,2]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[2,2],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF #FUN-C80107 add
 
         #(庫存不足是否允許工單發料退料過帳還原)
         WHEN g_prog[1,7]='asfi511' OR g_prog[1,7]='asfi512' OR g_prog[1,7]='asfi513' OR 
              g_prog[1,7]='asfi514' OR g_prog[1,7]='asfi526' OR g_prog[1,7]='asfi527' OR 
              g_prog[1,7]='asfi528' OR g_prog[1,7]='asfi529' OR
              g_prog[1,7]='asfi510' OR g_prog[1,7]='asfi520' OR
              g_prog[1,7]='asri210' OR g_prog[1,7]='asri220' OR g_prog[1,7]='asri230' #FUN-5C0114
             #IF g_sma894[3,3]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[3,3],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add  #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF        #FUN-C80107 add
              
         #(庫存不足是否允許調撥出庫)
         WHEN g_prog='aimp400' OR g_prog='aimp401' OR g_prog='aimp700' OR 
              g_prog='aimp701' OR g_prog[1,7]='aimt324' OR g_prog[1,7]='aimt325' OR
              g_prog='aimp378'
             #IF g_sma894[4,4]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[4,4],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF        #FUN-C80107 add
              
         #(庫存不足是否允許還料出庫)
         WHEN g_prog='aimt306' OR g_prog='aimt309'
             #IF g_sma894[5,5]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[5,5],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF        #FUN-C80107 add
              
         #(庫存不足是否允許採購退庫過帳及入庫過帳還原)
         WHEN g_prog[1,7]='apmt720' OR g_prog[1,7]='apmt721' OR g_prog[1,7]='apmt722' OR
              g_prog[1,7]='apmt730' OR g_prog[1,7]='apmt731' OR g_prog[1,7]='apmt732' OR
              g_prog[1,7]='apmt740' OR g_prog[1,7]='apmt732' OR
              g_prog[1,7]='asft620' OR g_prog[1,7]='asft622' OR    #No.B404 add
              g_prog[1,7]='asrt320' OR #FUN-5C0114
              g_prog[1,7]='aict042' OR g_prog[1,7]='aict043' OR  #CHI-830025
              g_prog[1,7]='aict044' #CHI-830025
             #IF g_sma894[6,6]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[6,6],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new 
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF        #FUN-C80107 add
             
         #(庫存不足是否允許銷退過帳還原)
         WHEN g_prog[1,7]='axmt700' OR g_prog[1,7]='axmt840' OR g_prog='axmp750' OR
              g_prog='axmp870' OR
              g_prog='apmp841' OR      #No.8276 add
              g_prog='axmp866'         #No.9316 add
             #IF g_sma894[7,7]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[7,7],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF        #FUN-C80107 add
            
         #(是否允許盤點過帳後庫存為負)
         WHEN g_prog='aimp880' OR g_prog='aimt307' OR g_prog='aimp920'
             #IF g_sma894[8,8]='N' THEN LET l_flag = 'Y' END IF   #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[8,8],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF        #FUN-C80107 add
           
         OTHERWISE
              LET l_flag = 'N'
    END CASE
    #################################################################
 
    IF p_type = -1 THEN           #出庫
       #檢查是否有足夠庫存供扣帳
       LET l_sql = " SELECT imgg10 ",
               #"   FROM ",p_dbs CLIPPED,"imgg_file ",
                #"   FROM ",p_dbs_tra CLIPPED,"imgg_file ",  #FUN-980094
                "   FROM ",cl_get_target_table(g_plant_new,'imgg_file'), #FUN-A50102
               	"  WHERE imgg01 = '",p_part,"'",
               	"    AND imgg02 = '",p_ware,"'",
               	"    AND imgg03 = '",p_loca,"'",
               	"    AND imgg04 = '",p_lot,"'",
                "    AND imgg09 = '",p_unit,"'"
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
       PREPARE imgg_prepare FROM l_sql
       IF SQLCA.sqlcode THEN 
          LET g_msg = p_dbs_tra CLIPPED,'imgg_prepare'
#         CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         LET g_showmsg = p_part,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_unit  
         CALL s_errmsg('imgg01,imgg02,imgg03,imgg04,imgg09',g_showmsg,g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
          LET g_success = 'N'
          RETURN
       END IF
       DECLARE imgg_curs CURSOR FOR imgg_prepare
       OPEN imgg_curs
       FETCH imgg_curs INTO l_imgg10
       IF SQLCA.sqlcode THEN
          LET g_msg = p_dbs_tra CLIPPED,'fetch imgg_curs'
#         CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end            
          LET g_success = 'N'
          RETURN
       END IF
       CLOSE imgg_curs
       IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
       IF l_imgg10 < p_qty THEN
         #IF g_sma894[2,2] = 'N' THEN  #庫存不足是否允許出貨扣帳
          IF l_flag='Y'          THEN  #庫存不足是否允許出貨扣帳 #No.8276
#             CALL cl_err(p_dbs,'aim-406',1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',p_dbs_tra,'aim-406',1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(p_dbs_tra,'aim-406',1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
             LET g_success = 'N'
             RETURN
          END IF
       END IF
       
      #LET l_sql = " UPDATE ",p_dbs CLIPPED,"imgg_file ",
       #LET l_sql = " UPDATE ",p_dbs_tra CLIPPED,"imgg_file ",  #FUN-980094
       LET l_sql = " UPDATE ",cl_get_target_table(g_plant_new,'imgg_file'), #FUN-A50102 
                   "    SET imgg10 = imgg10 - ?,",
                   "        imgg16 = ? ,",
                   "        imgg17 = ?  ",
                   "  WHERE imgg01 = ? AND imgg02 = ? ", 
                   "    AND imgg03 = ? AND imgg04 = ? ",
                   "    AND imgg09 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
       PREPARE updimgg_pre1 FROM l_sql
       IF SQLCA.sqlcode THEN
          LET g_msg = p_dbs_tra CLIPPED,'updimgg_pre1'
#         CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end           
          LET g_success = 'N'
          RETURN
       END IF
       EXECUTE updimgg_pre1 USING p_qty,p_date,p_date,
                                 p_part,p_ware,p_loca,p_lot,p_unit
       IF STATUS THEN
          LET g_msg = p_dbs_tra CLIPPED,'upd imgg10'
#         CALL cl_err(g_msg,STATUS,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',g_msg,STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,STATUS,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
          LET g_success='N' RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          LET g_msg = p_dbs_tra CLIPPED,'upd imgg10'
#         CALL cl_err(g_msg CLIPPED,'axm-176',1) 
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',g_msg CLIPPED,'axm-176',1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg CLIPPED,'axm-176',1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
          LET g_success='N' RETURN
       END IF
    END IF
    IF p_type = +1 THEN           #入庫
      #LET l_sql = " UPDATE ",p_dbs CLIPPED,"imgg_file ",
       #LET l_sql = " UPDATE ",p_dbs_tra CLIPPED,"imgg_file ", #FUN-980094
       LET l_sql = " UPDATE ",cl_get_target_table(g_plant_new,'imgg_file'), #FUN-A50102
                   "    SET imgg10 = imgg10 + ? ,",
                   "        imgg15 = ? ,",
                   "        imgg17 = ? ",
                   "  WHERE imgg01 = ? AND imgg02 = ? ", 
                   "    AND imgg03 = ? AND imgg04 = ? ",
                   "    AND imgg09 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
       PREPARE updimgg_pre2 FROM l_sql
       IF SQLCA.sqlcode THEN
          LET g_msg = p_dbs_tra CLIPPED,'updimgg_pre2'
#         CALL cl_err(g_msg,SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end  
          LET g_success = 'N'
          RETURN
       END IF
       EXECUTE updimgg_pre2 USING p_qty,p_date,p_date,
                                 p_part,p_ware,p_loca,p_lot,p_unit
       IF STATUS THEN
          LET g_msg = p_dbs_tra CLIPPED,'upd imgg10'
#         CALL cl_err(g_msg CLIPPED,STATUS,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',g_msg CLIPPED,STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg CLIPPED,STATUS,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
           LET g_success='N' RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          LET g_msg = p_dbs_tra CLIPPED,'upd imgg10'
#         CALL cl_err(g_msg CLIPPED,'axm-176',1) 
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',g_msg CLIPPED,'axm-176',1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg CLIPPED,'axm-176',1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end           
          LET g_success='N' RETURN
       END IF
    END IF
END FUNCTION
