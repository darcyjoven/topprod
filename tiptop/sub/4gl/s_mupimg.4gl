# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_mupimg.4gl
# Descriptions...: 多角貿易更新img (可指定資料庫)
# Date & Author..: No.7993 03/09/1 By Kammy 
# Usage..........: CALL s_mupimg(p_type,p_part,p_ware,p_loca,p_lot,p_qty,p_date,p_plant,p_rvbs09,p_no,p_line)
# Input Parameter: p_type       +1 入庫 -1 出庫
#                  p_part       料件 
#                  p_ware       倉庫
#                  p_loca       儲位
#                  p_lot        批號
#                  p_qty        異動數量
#                  p_date       異動日期 
#                  p_plant      機構別       
#                  p_rvbs09     屬性  
#                  p_no         異動單號
#                  p_line       異動項次
# Return code....: 
# Modify.........: No:9316 04/04/30 By ching sma894 應提前取得才正確
# Modify.........: No.MOD-530408 05/08/10 By Rosayu 1.加入apmp822
# Modify.........: No.FUN-610057 06/01/13 By Carrier add axmt627/axmt628
# Modify.........: No.FUN-5C0114 06/02/20 By kim add asri210/220/230/asrt320
# Modify.........: No.FUN-640053 06/04/09 By Sarah add atmt321
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.MOD-680078 06/11/16 By Claire 加入axmp865
# Modify.........: No.FUN-670012 07/02/05 By ching 行業別 add g_prog[1,7]
# Modify.........: No.FUN-720003 07/02/05 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-830025 08/03/19 By kim GP5.1 整合測試修改
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.TQC-910043 09/01/16 By claire 上述說明加入p_date
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun INSERT寫法修改
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun 傳值修改p_dbs->p_plant
# Modify.........: No.FUN-980014 09/09/14 By rainy s_gettrandbs() 存db變數改 g_dbs_tra
# Modify.........: No:FUN-990061 09/09/29 By mike 做库存是否足够判断时希望能加上仓/储/批/料号等资讯 
# Modify.........: No.FUN-TQC-9A0109 09/10/23 By sunyanchun   post to area 32
# Modify.........: No:FUN-A10099 10/02/02 By Carrier select ima時,寫成跨db寫法
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A90149 10/09/28 By Smapmin axmp830還原時,原先入庫的量要扣回去,但不要檢核是不是庫存不足.
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No:FUN-C70014 12/07/11 By wangwei 新增RUN CARD發料作業
# Modify.........: No:FUN-C80107 12/09/17 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30044 13/03/19 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30054 13/03/21 By lixh1 FUN-D30024所做的修改在正式區被還原,故重新過單
# Modify.........: No:TQC-D40078 13/04/27 By fengrui 負庫存函數添加營運中心參數

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
DEFINE g_msg      LIKE type_file.chr1000 #No.FUN-680147 VARCHAR(72)
DEFINE g_ima918   LIKE ima_file.ima918  #No.FUN-850100
DEFINE g_ima921   LIKE ima_file.ima921  #No.FUN-850100
DEFINE g_flag     LIKE type_file.chr1   #FUN-C80107 add
 
#FUNCTION s_mupimg(p_type,p_part,p_ware,p_loca,p_lot,p_qty,p_date,p_dbs,p_rvbs09,p_no,p_line) #No.FUN-870007-mark  #TQC-D30054
FUNCTION s_mupimg(p_type,p_part,p_ware,p_loca,p_lot,p_qty,p_date,p_plant,p_rvbs09,p_no,p_line) #No.FUN-870007 
  DEFINE l_sql     LIKE type_file.chr1000      #No.FUN-680147 VARCHAR(600)
  #DEFINE g_sma894  LIKE sma_file.sma894 #TQC-D30044 mark
  DEFINE l_img10   LIKE img_file.img10
  DEFINE p_type    LIKE type_file.num5         #No.FUN-680147 SMALLINT
  DEFINE p_part    LIKE img_file.img01,        ##料號
         p_ware    LIKE img_file.img02,        ##倉庫
         p_loca    LIKE img_file.img03,        ##儲位 
         p_lot     LIKE img_file.img04,        ##批號
         p_qty     LIKE img_file.img10,        #No.FUN-680147 DECIMAL (11,3)          ##數量
         p_date    LIKE type_file.dat,         #No.FUN-680147 DATE ##異動日期
         p_dbs     LIKE type_file.chr21,       #No.FUN-680147 VARCHAR(21)
         p_tdbs    LIKE type_file.chr21,       #No.FUN-980014 add 存放TRANS DB
         p_rvbs09  LIKE rvbs_file.rvbs09,  #No.FUN-850100
         p_no      LIKE img_file.img05,  #No.FUN-850100
         p_line    LIKE img_file.img06,  #No.FUN-850100
         l_flag    LIKE type_file.chr1         #是否控制庫存量不得為負(Y/N)        #No.FUN-680147 VARCHAR(1)
 DEFINE  p_plant   LIKE type_file.chr20  #No.FUN-870007
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_part,p_plant) OR NOT s_internal_item( p_part,p_plant ) THEN
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
 
    IF p_part[1,4]='MISC' THEN RETURN END IF  #No.8743
 
    MESSAGE p_dbs CLIPPED,"u_img!"
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF   #NO.TQC-9A0109
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
 
#No.FUN-870007-start-
    LET g_plant_new = p_plant
  ##FUN-980014 modify begin
    #CALL s_gettrandbs()
    #LET p_dbs=g_dbs_new
    CALL s_getdbs()
    LET p_dbs=g_dbs_new
    CALL s_gettrandbs()
    LET p_tdbs=g_dbs_tra
  ##FUN-980014 modify end
#No.FUN-870007--end--
   
#TQC-D30044--mark--str--
#    #No.9316
#    #LET l_sql = "SELECT sma894 FROM ",p_dbs CLIPPED, "sma_file",
#    LET l_sql = "SELECT sma894 FROM ",cl_get_target_table(g_plant_new,'sma_file'), #FUN-A50102
#                " WHERE sma00 = '0' "
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
#    PREPARE sma_pre FROM l_sql
#    DECLARE sma_cs CURSOR FOR sma_pre
#    OPEN sma_cs
#    FETCH sma_cs INTO g_sma894   #No.8048
#    IF SQLCA.sqlcode THEN
#      LET g_msg = p_dbs CLIPPED,"sel sma894"
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
 
    #No.8276 同 s_upimg處理
    ####################################################################
    ## 依主程式代號加上參數sma894決定是否控制庫存量不可為負
    #g_sma.sma894-->g_sma894#9316
    LET g_flag = NULL    #FUN-C80107 add
    CASE 
         #(庫存不足是否許雜項發料及報廢)
         WHEN g_prog[1,7]='aimt301' OR g_prog[1,7]='aimt302' OR g_prog[1,7]='aimt303' OR 
              g_prog[1,7]='aimt311' OR g_prog[1,7]='aimt312' OR g_prog[1,7]='aimt313' OR
              g_prog='aimp379' 
             #IF g_sma894[1,1]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[1,1],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag  #FUN-D30024 add  #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF       #FUN-C80107 add
 
         #(庫存不足是否允許出貨扣帳)
         WHEN g_prog[1,7]='axmt650' OR g_prog[1,7]='axmt610' OR g_prog[1,7]='axmt620'
              OR g_prog='axmt627' OR g_prog='axmt628'  #No.FUN-610057
              #OR g_prog='axmp820' OR g_prog='axmp900' OR g_prog='axmp830'   #MOD-A90149
              OR g_prog='axmp820' OR g_prog='axmp900' OR (g_prog='axmp830' AND (p_type<>'-1' OR p_rvbs09<>'-1'))  #MOD-A90149
              OR g_prog='axmp901' 
	      OR g_prog='axmp910' OR g_prog='axmp911'
              OR g_prog='apmp822' #MOD-530408 add 
              OR g_prog='atmt321' #FUN-640053 add
             #IF g_sma894[2,2]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[2,2],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF       #FUN-C80107 add
 
         #(庫存不足是否允許工單發料退料過帳還原)
         WHEN g_prog[1,7]='asfi511' OR g_prog[1,7]='asfi512' OR g_prog[1,7]='asfi513' OR 
              g_prog[1,7]='asfi514' OR g_prog[1,7]='asfi526' OR g_prog[1,7]='asfi527' OR 
              g_prog[1,7]='asfi528' OR g_prog[1,7]='asfi529' OR g_prog[1,7]='asfi519' OR     #FUN-C70014 add g_prog[1,7]='asfi519'
              g_prog[1,7]='asfi510' OR g_prog[1,7]='asfi520' OR
              g_prog[1,7]='asri210' OR g_prog[1,7]='asri220' OR g_prog[1,7]='asri230' #FUN-5C0114
             #IF g_sma894[3,3]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[3,3],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF       #FUN-C80107 add
              
         #(庫存不足是否允許調撥出庫)
         WHEN g_prog='aimp400' OR g_prog='aimp401' OR g_prog='aimp700' OR 
              g_prog='aimp701' OR g_prog[1,7]='aimt324' OR g_prog[1,7]='aimt325' OR
              g_prog='aimp378'
             #IF g_sma894[4,4]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[4,4],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF       #FUN-C80107 add
              
         #(庫存不足是否允許還料出庫)
         WHEN g_prog='aimt306' OR g_prog='aimt309'
             #IF g_sma894[5,5]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[5,5],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF       #FUN-C80107 add
              
         #(庫存不足是否允許採購退庫過帳及入庫過帳還原)
         WHEN g_prog[1,7]='apmt720' OR g_prog[1,7]='apmt721' OR g_prog[1,7]='apmt722' OR
              g_prog[1,7]='apmt730' OR g_prog[1,7]='apmt731' OR g_prog[1,7]='apmt732' OR
              g_prog[1,7]='apmt740' OR g_prog[1,7]='apmt732' OR
              g_prog[1,7]='asft620' OR g_prog[1,7]='asft622' OR    #No.B404 add
              g_prog='axmp865' OR                      #MOD-680078 add
              g_prog[1,7]='asrt320' OR #FUN-5C0114
              g_prog[1,7]='aict042' OR g_prog[1,7]='aict043' OR #CHI-830025 
              g_prog[1,7]='aict044'    #CHI-830025
             #IF g_sma894[6,6]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[6,6],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF       #FUN-C80107 add
             
         #(庫存不足是否允許銷退過帳還原)
         WHEN g_prog[1,7]='axmt700' OR g_prog[1,7]='axmt840' OR g_prog='axmp750' OR
              g_prog='axmp870' OR
              g_prog='apmp841' OR      #No.8276 add
              g_prog='axmp866'         #No.9316 add
             #IF g_sma894[7,7]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[7,7],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF       #FUN-C80107 add
            
         #(是否允許盤點過帳後庫存為負)
         WHEN g_prog='aimp880' OR g_prog='aimt307' OR g_prog='aimp920'
             #IF g_sma894[8,8]='N' THEN LET l_flag = 'Y' END IF  #FUN-C80107 mark
             #CALL s_inv_shrt_by_warehouse(g_sma894[8,8],p_ware) RETURNING g_flag  #FUN-C80107 add #FUN-D30024 mark 
              CALL s_inv_shrt_by_warehouse(p_ware,g_plant_new) RETURNING g_flag    #FUN-D30024 add #TQC-D40078 g_plant_new
              IF g_flag = 'N' THEN LET l_flag = 'Y' END IF       #FUN-C80107 add
           
         OTHERWISE
              LET l_flag = 'N'
    END CASE
    #################################################################
 
    IF p_type = -1 THEN           #出庫
       #檢查是否有足夠庫存供扣帳
       LET l_sql = " SELECT img10 ",
               	#"   FROM ",p_dbs CLIPPED,"img_file ",  #FUN-980014
               	#"   FROM ",p_tdbs CLIPPED,"img_file ",  #FUN-980014
                "   FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
               	"  WHERE img01 = '",p_part,"'",
               	"    AND img02 = '",p_ware,"'",
               	"    AND img03 = '",p_loca,"'",
               	"    AND img04 = '",p_lot,"'" 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #No.FUN-870007
       PREPARE img_prepare FROM l_sql
       IF SQLCA.sqlcode THEN 
          #LET g_msg = p_dbs CLIPPED,'img_prepare'   #FUN-980014
          LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' img_prepare' #FUN-980014
#         CALL cl_err(g_msg,SQLCA.sqlcode,1)
 
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         LET g_showmsg = p_part,"/",p_ware,"/",p_loca,"/",p_lot
         CALL s_errmsg('img01,img02,img03,img04',g_showmsg,g_msg,SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
          LET g_success = 'N'
          RETURN
       END IF
       DECLARE img_curs CURSOR FOR img_prepare
       OPEN img_curs
       FETCH img_curs INTO l_img10
       IF SQLCA.sqlcode THEN
          #LET g_msg = p_dbs CLIPPED,'fetch img_curs' #FUN-980014
          LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' fetch img_curs' #FUN-980014
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
       CLOSE img_curs
       IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
       IF l_img10 < p_qty THEN
         #IF g_sma894[2,2] = 'N' THEN  #庫存不足是否允許出貨扣帳
          IF l_flag='Y'          THEN  #庫存不足是否允許出貨扣帳 #No.8276
#            CALL cl_err(p_dbs,'aim-406',1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         #CALL s_errmsg('','',p_dbs,'aim-406',1)   #FUN-980014                                                                  
         #CALL s_errmsg('','',p_plant,'aim-406',1)  #FUN-980014 #FUN-990061                                                            
          CALL s_errmsg('','',p_plant||' '||p_ware||'/'||p_loca||'/'||p_lot||'/'||p_part,'aim-406',1) #FUN-990061                      
      ELSE                                                                                                                          
         #CALL cl_err(p_dbs,'aim-406',1)    #FUN-980014 
         #CALL cl_err(p_plant,'aim-406',1)   #FUN-980014  #FUN-990061                                                                             
          CALL cl_err(p_plant||' '||p_ware||'/'||p_loca||'/'||p_lot||'/'||p_part,'aim-406',1) #FUN-990061                              
      END IF                                                                                                                        
#No.FUN-720003--end   
             LET g_success = 'N'
             RETURN
          END IF
       END IF
       
       #LET l_sql = " UPDATE ",p_dbs CLIPPED,"img_file ",   #FUN-980014
       #LET l_sql = " UPDATE ",p_tdbs CLIPPED,"img_file ",   #FUN-980014
       LET l_sql = " UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                   "    SET img10 = img10 - ?,",
                   "        img16 = ? ,",
                   "        img17 = ?  ",
                   "  WHERE img01 = ? AND img02 = ? ", 
                   "    AND img03 = ? AND img04 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #No.FUN-870007
       PREPARE updimg_pre1 FROM l_sql
       IF SQLCA.sqlcode THEN
          #LET g_msg = p_dbs CLIPPED,'updimg_pre1'   #FUN-980014
          LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' updimg_pre1'   #FUN-980014
#          CALL cl_err(g_msg,SQLCA.sqlcode,1)
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
       EXECUTE updimg_pre1 USING p_qty,p_date,p_date,
                                 p_part,p_ware,p_loca,p_lot
       IF STATUS THEN
          #LET g_msg = p_dbs CLIPPED,'upd img10'    #FUN-980014
          LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' upd img10'   #FUN-980014
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
          #LET g_msg = p_dbs CLIPPED,'upd img10'
          LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' upd img10'   #FUN-980014
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
       #-----No.FUN-850100-----
       #No.FUN-A10099  --Begin
       #SELECT ima918,ima921 INTO g_ima918,g_ima921
       #  FROM ima_file
       # WHERE ima01 = p_part
       #   AND imaacti = "Y"
       CALL s_mupimg_sel_ima(p_part,p_plant) RETURNING g_ima918,g_ima921
       IF g_success = 'N' THEN RETURN END IF
       #No.FUN-A10099  --End

       IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          #CALL s_mupimg_imgs(p_part,p_ware,p_loca,p_lot,p_type,p_rvbs09,p_no,p_line,p_dbs)   #FUN-980014
          CALL s_mupimg_imgs(p_part,p_ware,p_loca,p_lot,p_type,p_rvbs09,p_no,p_line,p_plant)  #FUN-980014
       END IF
       #-----No.FUN-850100 END-----
    END IF
    IF p_type = +1 THEN           #入庫
       #LET l_sql = " UPDATE ",p_dbs CLIPPED,"img_file ",    #FUN-980014
       #LET l_sql = " UPDATE ",p_tdbs CLIPPED,"img_file ",    #FUN-980014
       LET l_sql = " UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                   "    SET img10 = img10 + ? ,",
                   "        img15 = ? ,",
                   "        img17 = ? ",
                   "  WHERE img01 = ? AND img02 = ? ", 
                   "    AND img03 = ? AND img04 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #No.FUN-870007
       PREPARE updimg_pre2 FROM l_sql
       IF SQLCA.sqlcode THEN
          #LET g_msg = p_dbs CLIPPED,'updimg_pre2'     #FUN-980014
          LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' updimg_pre2'   #FUN-980014
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
       EXECUTE updimg_pre2 USING p_qty,p_date,p_date,
                                 p_part,p_ware,p_loca,p_lot
       IF STATUS THEN
          #LET g_msg = p_dbs CLIPPED,'upd img10'    #FUN-980014
          LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' upd img10'   #FUN-980014
#         CALL cl_err(g_msg,SQLCA.sqlcode,1)
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
          #LET g_msg = p_dbs CLIPPED,'upd img10'   #FUN-980014
          LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' upd img10'   #FUN-980014
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
       #-----No.FUN-850100-----
       #No.FUN-A10099  --Begin
       #SELECT ima918,ima921 INTO g_ima918,g_ima921
       #  FROM ima_file
       # WHERE ima01 = p_part
       #   AND imaacti = "Y"
       CALL s_mupimg_sel_ima(p_part,p_plant) RETURNING g_ima918,g_ima921
       IF g_success = 'N' THEN RETURN END IF
       #No.FUN-A10099  --End
            
       IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          #CALL s_mupimg_imgs(p_part,p_ware,p_loca,p_lot,p_type,p_rvbs09,p_no,p_line,p_dbs)   #FUN-980014
          CALL s_mupimg_imgs(p_part,p_ware,p_loca,p_lot,p_type,p_rvbs09,p_no,p_line,p_plant)  #FUN-980014
       END IF
       #-----No.FUN-850100 END-----
    END IF
END FUNCTION
 
#-----No.FUN-850100-----
#FUNCTION s_mupimg_imgs(p_part,p_ware,p_loca,p_lot,p_type,p_rvbs09,p_no,p_line,p_dbs)    #FUN-980014
FUNCTION s_mupimg_imgs(p_part,p_ware,p_loca,p_lot,p_type,p_rvbs09,p_no,p_line,p_plant)   #FUN-980014
   DEFINE p_part    LIKE img_file.img01,        ##料號
          p_ware    LIKE img_file.img02,        ##倉庫
          p_loca    LIKE img_file.img03,        ##儲位 
          p_lot     LIKE img_file.img04,        ##批號
          p_type    LIKE type_file.num5,
          p_rvbs09  LIKE rvbs_file.rvbs09,
          p_no      LIKE img_file.img05,
          p_line    LIKE img_file.img06,
          p_dbs     LIKE type_file.chr21,
          p_tdbs    LIKE type_file.chr21   #FUN-980014 add
   DEFINE p_plant   LIKE azp_file.azp01    #FUN-980014 add
   DEFINE l_sql   STRING
   DEFINE l_rvbs  RECORD LIKE rvbs_file.*
   DEFINE l_imgs08   LIKE imgs_file.imgs08
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
 
   IF g_success = "N" THEN
      RETURN
   END IF
 
  ##FUN-980014 add begin
    LET g_plant_new = p_plant
    CALL s_getdbs()
    LET p_dbs=g_dbs_new
    CALL s_gettrandbs()
    LET p_tdbs=g_dbs_tra
  ##FUN-980014 add end
 
   #No.FUN-A10099  --Begin
   #SELECT ima918,ima921 INTO l_ima918,l_ima921
   #  FROM ima_file
   # WHERE ima01 = p_part
   #   AND imaacti = "Y"
   CALL s_mupimg_sel_ima(p_part,p_plant) RETURNING l_ima918,l_ima921
   IF g_success = 'N' THEN RETURN END IF
   #No.FUN-A10099  --End
   
   IF cl_null(l_ima918) THEN
      LET l_ima918='N'
   END IF
                                                                                
   IF cl_null(l_ima921) THEN
      LET l_ima921='N'
   END IF
 
   IF l_ima918 = "N" AND l_ima921 = "N" THEN
      RETURN
   END IF
 
   IF p_type = -1 THEN
      LET l_sql = "SELECT * ",
               	  #"  FROM ",p_dbs CLIPPED,"rvbs_file ",   #FUN-980014
               	  #"  FROM ",p_tdbs CLIPPED,"rvbs_file ",   #FUN-980014
                  "  FROM ",cl_get_target_table(g_plant_new,'rvbs_file'), #FUN-A50102
                  " WHERE rvbs01 = '",p_no,"'",
                 "   AND rvbs02 = ",p_line,  
                  "   AND rvbs09 = ",p_rvbs09
      
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #No.FUN-870007
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
      
         LET l_sql = "SELECT imgs08 ",
                     #"  FROM ",p_dbs CLIPPED,"imgs_file ",  #FUN-980014
                     #"  FROM ",p_tdbs CLIPPED,"imgs_file ",  #FUN-980014
                     "  FROM ",cl_get_target_table(g_plant_new,'imgs_file'), #FUN-A50102
                     " WHERE imgs01 = '",p_part,"'",
                     "   AND imgs02 = '",p_ware,"'",
                     "   AND imgs03 = '",p_loca,"'",
                     "   AND imgs04 = '",p_lot,"'", 
                     "   AND imgs05 = '",l_rvbs.rvbs03,"'", 
                     "   AND imgs06 = '",l_rvbs.rvbs04,"'",
                     "   AND imgs11 = '",l_rvbs.rvbs08,"'" 
         
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #No.FUN-870007
         PREPARE imgs_pre1 FROM l_sql
         DECLARE imgs_cs1 CURSOR FOR imgs_pre1
      
         OPEN imgs_cs1
         FETCH imgs_cs1 INTO l_imgs08
 
         IF STATUS OR l_imgs08 IS NULL THEN
            LET g_success='N'
            IF g_bgerr THEN
               CALL s_errmsg('ima01',p_part,'imgs_file','asf-375',1)
            ELSE
               CALL cl_err('imgs_file','asf-375',1)
            END IF
            RETURN
         END IF
      
         LET l_imgs08 = l_imgs08 - l_rvbs.rvbs06
 
         #LET l_sql = " UPDATE ",p_dbs CLIPPED,"imgs_file ",    #FUN-980014
         #LET l_sql = " UPDATE ",p_tdbs CLIPPED,"imgs_file ",    #FUN-980014
         LET l_sql = " UPDATE ",cl_get_target_table(g_plant_new,'imgs_file'), #FUN-A50102
                     "    SET imgs08 = ? ",
                     "  WHERE imgs01 = ? ",
                     "    AND imgs02 = ? ", 
                     "    AND imgs03 = ? ",
                     "    AND imgs04 = ? ",
                     "    AND imgs05 = ? ",
                     "    AND imgs06 = ? ",
                     "    AND imgs11 = ? "
      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #No.FUN-870007
         PREPARE updimgs_pre1 FROM l_sql
         IF SQLCA.sqlcode THEN
            #LET g_msg = p_dbs CLIPPED,'updimgs_pre1'  #FUN-980014
            LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' updimgs_pre1'  #FUN-980014
            IF g_bgerr THEN                                                                                                               
               CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)                                                                     
            ELSE                                                                                                                          
               CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
            END IF                                                                                                                        
            LET g_success = 'N'
            RETURN
         END IF
 
         EXECUTE updimgs_pre1 USING l_imgs08,p_part,p_ware,p_loca,p_lot,
                                    l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs08
 
         IF STATUS THEN
            #LET g_msg = p_dbs CLIPPED,'upd imgs08'  #FUN-980014
            LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' upd imgs08'  #FUN-980014
            IF g_bgerr THEN                                                                                                               
               CALL s_errmsg('','',g_msg,STATUS,1)                                                                     
            ELSE                                                                                                                          
               CALL cl_err(g_msg,STATUS,1)                                                                             
            END IF                                                                                                                        
            LET g_success='N'
            RETURN
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            #LET g_msg = p_dbs CLIPPED,'upd imgs09'  #FUN-980014
            LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' upd imgs09'  #FUN-980014
            IF g_bgerr THEN                                                                                                               
               CALL s_errmsg('','',g_msg CLIPPED,'asf-375',1)                                                                     
            ELSE                                                                                                                          
               CALL cl_err(g_msg CLIPPED,'asf-375',1)                                                                             
            END IF                                                                                                                        
            LET g_success='N'
            RETURN
         END IF
 
      END FOREACH
   END IF
 
   IF p_type = 1 THEN
 
      LET l_sql = "SELECT * ",
               	  #"  FROM ",p_dbs CLIPPED,"rvbs_file ",   #FUN-980014
               	  #"  FROM ",p_tdbs CLIPPED,"rvbs_file ",   #FUN-980014
                  "  FROM ",cl_get_target_table(g_plant_new,'rvbs_file'), #FUN-A50102
                  " WHERE rvbs01 = '",p_no,"'",
                  "   AND rvbs02 = ",p_line,
                  "   AND rvbs09 = ",p_rvbs09
      
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #No.FUN-870007
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
      
         LET l_imgs08 = NULL
      
         LET l_sql = "SELECT imgs08 ",
                     #"  FROM ",p_dbs CLIPPED,"imgs_file ",    #FUN-980014
                     #"  FROM ",p_tdbs CLIPPED,"imgs_file ",    #FUN-980014
                     "  FROM ",cl_get_target_table(g_plant_new,'imgs_file'), #FUN-A50102
                     " WHERE imgs01 = '",p_part,"'",
                     "   AND imgs02 = '",p_ware,"'",
                     "   AND imgs03 = '",p_loca,"'",
                     "   AND imgs04 = '",p_lot,"'", 
                     "   AND imgs05 = '",l_rvbs.rvbs03,"'", 
                     "   AND imgs06 = '",l_rvbs.rvbs04,"'",
                     "   AND imgs11 = '",l_rvbs.rvbs08,"'" 
         
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #No.FUN-870007
         PREPARE imgs_pre2 FROM l_sql
         DECLARE imgs_cs2 CURSOR FOR imgs_pre2
      
         OPEN imgs_cs2
         FETCH imgs_cs2 INTO l_imgs08
 
         IF STATUS = 100 THEN
            #LET l_sql = "INSERT INTO ",p_dbs CLIPPED,"imgs_file",   #FUN-980014
            #LET l_sql = "INSERT INTO ",p_tdbs CLIPPED,"imgs_file",   #FUN-980014
            LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'imgs_file'), #FUN-A50102
                        "(imgs01,imgs02,imgs03,imgs04,imgs05,",        #No.TQC-930155
                        " imgs06,imgs07,imgs08,imgs09,imgs10,imgs11,imgsplant,imgslegal)",  #No.FUN-870007
                        "      VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?) "                          #No.FUN-870007
#                        " imgs06,imgs07,imgs08,imgs09,imgs10,imgs11)", #No.TQC-930155      #No.FUN-870007-mark
#                        "     VALUES(?,?,?,?,?,?,?,?,?,?,?) "                              #No.FUN-870007-mark
 
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
            PREPARE ins_imgs FROM l_sql
 
            EXECUTE ins_imgs USING p_part,p_ware,p_loca,p_lot,
                                   l_rvbs.rvbs03,l_rvbs.rvbs04,l_imgs08,
                                   l_rvbs.rvbs06,l_rvbs.rvbs05,l_rvbs.rvbs07,
#                                  l_rvbs.rvbs08                                     #No.FUN-870007-mark
                                   l_rvbs.rvbs08,l_rvbs.rvbsplant,l_rvbs.rvbslegal   #No.FUN-870007
 
            IF SQLCA.sqlcode THEN
               LET g_success='N' 
               IF g_bgerr THEN
                  CALL s_errmsg('imgs01',p_part,'(s_upimgs)',SQLCA.sqlcode,1)
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
                  CALL s_errmsg('ima01',p_part,'imgs_file','asf-375',1)
               ELSE
                  CALL cl_err('imgs_file','asf-375',1)
               END IF
               RETURN
            END IF 
         END IF
      
         LET l_imgs08 = l_imgs08 + l_rvbs.rvbs06
      
         #LET l_sql = " UPDATE ",p_dbs CLIPPED,"imgs_file ",    #FUN-980014
         #LET l_sql = " UPDATE ",p_tdbs CLIPPED,"imgs_file ",    #FUN-980014
         LET l_sql = " UPDATE ",cl_get_target_table(g_plant_new,'imgs_file'), #FUN-A50102
                     "    SET imgs08 = ?, ",
                     "        imgs09 = ?  ",
                     "  WHERE imgs01 = ? ",
                     "    AND imgs02 = ? ", 
                     "    AND imgs03 = ? ",
                     "    AND imgs04 = ? ",
                     "    AND imgs05 = ? ",
                     "    AND imgs06 = ? ",
                     "    AND imgs11 = ? "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #No.FUN-870007
         PREPARE updimgs_pre2 FROM l_sql
         IF SQLCA.sqlcode THEN
            #LET g_msg = p_dbs CLIPPED,'updimgs_pre2'   #FUN-980014
            LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' updimgs_pre2' #FUN-980014
            IF g_bgerr THEN                                                                                                               
               CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)                                                                     
            ELSE                                                                                                                          
               CALL cl_err(g_msg,SQLCA.sqlcode,1)                                                                             
            END IF                                                                                                                        
            LET g_success = 'N'
            RETURN
         END IF
 
         EXECUTE updimgs_pre2 USING l_imgs08,l_rvbs.rvbs05,p_part,p_ware,p_loca,p_lot,
                                    l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs08
 
         IF STATUS THEN
            #LET g_msg = p_dbs CLIPPED,'upd imgs08,imgs09' #FUN-980014
            LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' upd imgs08,imgs09' #FUN-980014
            IF g_bgerr THEN                                                                                                               
               CALL s_errmsg('','',g_msg,STATUS,1)                                                                     
            ELSE                                                                                                                          
               CALL cl_err(g_msg,STATUS,1)                                                                             
            END IF                                                                                                                        
            LET g_success='N'
            RETURN
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            #LET g_msg = p_dbs CLIPPED,'upd imgs08,imgs09'  #FUN-980014
            LET g_msg = p_tdbs CLIPPED,'-',g_plant_new CLIPPED,' upd imgs08,imgs09' #FUN-980014
            IF g_bgerr THEN                                                                                                               
               CALL s_errmsg('','',g_msg CLIPPED,'asf-375',1)                                                                     
            ELSE                                                                                                                          
               CALL cl_err(g_msg CLIPPED,'asf-375',1)                                                                             
            END IF                                                                                                                        
            LET g_success='N'
            RETURN
         END IF
 
      END FOREACH
   END IF
 
END FUNCTION
#-----No.FUN-850100 END-----
#TQC-910043

#No.FUN-A10099  --Begin
FUNCTION s_mupimg_sel_ima(p_part,p_plant)
   DEFINE p_plant    LIKE azp_file.azp01 
   DEFINE p_dbs      LIKE type_file.chr21
   DEFINE p_tdbs     LIKE type_file.chr21
   DEFINE p_part     LIKE ima_file.ima01
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE l_sql      STRING

   LET g_plant_new = p_plant
   CALL s_getdbs()
   LET p_dbs=g_dbs_new
   CALL s_gettrandbs()
   LET p_tdbs=g_dbs_tra

   #LET l_sql = " SELECT ima918,ima921 FROM ",p_dbs CLIPPED,"ima_file",
   LET l_sql = " SELECT ima918,ima921 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
               "  WHERE ima01   = '",p_part,"'",
               "    AND imaacti = 'Y'"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
  PREPARE sel_ima_p1 FROM l_sql
   EXECUTE sel_ima_p1 INTO l_ima918,l_ima921
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('ima01',p_part,'select ima',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('select ima',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
      RETURN NULL,NULL
   END IF
   RETURN l_ima918,l_ima921
END FUNCTION
#No.FUN-A10099  --End

