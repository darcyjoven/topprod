# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_udima1.4gl
# Descriptions...: 更新庫存主檔之庫存數量
# Date & Author..: 92/05/26 By Pin
# Usage..........: IF s_udima1(p_item,p_img23,p_img24,p_qty,p_date,p_type,p_dbs)
# Input Parameter: p_item    欲更新之料件
#                  p_img23   倉儲可用否(多倉管理使用)
#                  p_img24   MRP/MPS 可用否(多倉管理使用)
#                  p_qty     欲更新之數量
#                  p_date    異動日期
#                  p_type    欲更新之方式
#                     +1   入庫
#                     0    報廢/退貨
#                     -1   出庫
#                     2    盤點
#                  p_dbs     資料庫編號
# Return code....: 1  FAIL
#                  0  OK
# Memo...........: 不成功時g_success為N
# Modify.........: 92/06/31 By david
# Modify.........: 92/11/17 By Jones 新增加的參數為: 工廠編號
#                  將所有對資料庫的動作都改成透過 prepare 的方式
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980020 09/09/23 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A30116 10/04/20 By  huangrh 修改多DB和201語法錯誤
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_udima1(p_item,p_img23,p_img24,p_qty,p_date,p_type,p_dbs)  #FUN-980020 mark
FUNCTION s_udima1(p_item,p_img23,p_img24,p_qty,p_date,p_type,p_plant) #FUN-980020
DEFINE
    p_item  LIKE ima_file.ima01,
	p_img23 LIKE img_file.img23,
	p_img24 LIKE img_file.img24,
#    p_qty LIKE ima_file.ima26,  #FUN-A20044
    p_qty LIKE type_file.num15_3,  #FUN-A20044
    p_date LIKE ima_file.ima29, #異動日期
    p_type LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    p_dbs  LIKE type_file.chr21,        #Server Name   	#No.FUN-680147 VARCHAR(21)
    l_sql  LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(1000)
DEFINE  p_plant  LIKE type_file.chr10   #No.FUN-980020
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#FUN-980020--begin    
    IF cl_null(p_plant) THEN
       LET p_dbs = NULL
    ELSE
       LET g_plant_new = p_plant
       CALL s_getdbs()
#       LET p_dbs = g_dbs_new       #FUN-A30116
       LET p_dbs = g_dbs_tra        #FUN-A30116
    END IF
#FUN-980020--end    
 
    IF p_type != 1 AND p_type != -1 AND p_type != 0 AND  p_type != 2
       THEN RETURN 1 
    END IF
	IF p_qty IS NULL THEN RETURN 1 END IF
#---------------------------------------------------------------------------#
#---->更新料件主檔分單倉管理與多倉管理
#     在多倉管理時須注意此倉是否為可用倉儲與是否mps/mrp可用否
#     a.當為可用倉儲且mps/mrp可用時, 則更新可用庫存量與mps/mrp可用量
#     b.當為可用倉儲且mps/mrp不可用時, 則更新可用庫存量
#     c.當為不可用倉儲且mps/mrp不可用時, 則更新料件不可用庫存量
#
    IF g_sma.sma12 MATCHES '[Nn]'    #單倉管理
	   THEN 
          CASE 
             WHEN p_type = 0   #報廢
      {ckp#1}  #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
               LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                         " SET ima26=ima26-",p_qty, #MPS/MRP可用庫存量  #FUN-A20044
#                         " , ima262=ima262-",p_qty,   #庫存數量#FUN-A20044
                         " SET ima29='",p_date,"'",     #異動日期
                         " , ima74='",p_date,"'",     #最近出庫日期
                         " WHERE ima01='",p_item,"'" CLIPPED
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ima_up FROM l_sql
#               DECLARE ima_up1 CURSOR FOR ima_up        
                EXECUTE ima_up
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_success='N' 
                   #CALL cl_err('(s_udima1:ckp#1)',SQLCA.sqlcode,1)  #FUN-670091
                    CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#01)",1)  #FUN-670091
                   RETURN 1
                END IF
             WHEN p_type = 1   #入庫
      {ckp#2}   #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
 #                         " SET ima26=ima26+",p_qty,  #庫存數量#FUN-A20044 
#                          " , ima262=ima262+",p_qty,    #庫存數量 #FUN-A20044
                          " SET ima29='",p_date,"'",       #異動日期
                          " , ima73='",p_date,"'",       #最近入庫日期
                          " WHERE ima01='",p_item,"'" CLIPPED
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ima_u2 FROM l_sql
#               DECLARE ima_up2 CURSOR FOR ima_u2        
                EXECUTE ima_u2
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_success='N' 
                   #CALL cl_err('(s_udima1:ckp#2)',SQLCA.sqlcode,1) #FUN-670091
                    CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#02)",1)  #FUN-670091
                   RETURN 1
                END IF
             WHEN p_type = -1   #出庫
      {ckp#3}   #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                          " SET ima26=ima26-",p_qty,   #MPS/MRP可用數量 #FUN-A20044
#                          " , ima262=ima262-",p_qty, #可用庫存數量 #FUN-A20044
					      " SET ima40=ima40+",p_qty,   #累計期間使用量
					      " , ima41=ima41+",p_qty,   #累計年度使用量
                          " , ima29='",p_date,"'",   #異動日期
                          " , ima74='",p_date,"'",   #最近出庫日期
                          " WHERE ima01='",p_item,"'" CLIPPED
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ima_u3 FROM l_sql
#               DECLARE ima_up3 CURSOR FOR ima_u3        
                EXECUTE ima_u3
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_success='N' 
                   #CALL cl_err('(s_udima1:ckp#3)',SQLCA.sqlcode,1) #FUN-670091
                   CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#03)",1)  #FUN-670091
                   RETURN 1
                END IF
             WHEN p_type = 2   #盤點
       {ckp#4}  #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                          " SET ima26=ima26 +", p_qty,   #MPS/MRP可用數量 #FUN-A20044
#                          " , ima262=ima262+",p_qty,   #可用庫存數量 #FUN-A20044
                          " SET ima29='",p_date,"'",          #異動日期
                          " , ima30='",p_date,"'",           #最近盤點日期
                          " WHERE ima01='",p_item,"'" CLIPPED
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                PREPARE ima_u4 FROM l_sql
#               DECLARE ima_up4 CURSOR FOR ima_u4      
                EXECUTE ima_u4
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_success='N' 
                   #CALL cl_err('(s_udima1:ckp#4)',SQLCA.sqlcode,1)
                    CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#04)",1)  #FUN-670091
                   RETURN 1
                END IF
             OTHERWISE EXIT CASE
          END CASE 
	   ELSE
          CASE 
             WHEN p_type = 0   #報廢
                 IF p_img23 MATCHES '[Yy]'             #可用倉
					THEN 
         {ckp#5}    IF p_img24 MATCHES '[Yy]' THEN    #mps/mrp 可用
                      # LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                       LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                                 " SET ima26=ima26-",p_qty,   #MPS/MRP可用數量 #FUN-A20044
#                                 " , ima262=ima262-",p_qty, #可用庫存數量 #FUN-A20044
#                                 "SET  ima29='",p_date,"'",      #異動日期 #FUN-A30116
                                 " SET  ima29='",p_date,"'",      #異動日期  #FUN-A30116
                                 " , ima74='",p_date,"'",       #最近出庫日期
                                 " WHERE ima01='",p_item,"'" CLIPPED
 	                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                       PREPARE ima_u5 FROM l_sql
#                      DECLARE ima_up5 CURSOR FOR ima_u5        
                       EXECUTE ima_u5
                            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                               LET g_success='N' 
                               #CALL cl_err('(s_udima1:ckp#5)',SQLCA.sqlcode,1) #FUN-670091
                               CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#05)",1)  #FUN-670091
                               RETURN 1
                            END IF
					ELSE
     {ckp#6}           #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file" ,
                       LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                                 " SET ima262=ima262-",p_qty, #可用庫存數量 #FUN-A20044
#                                 "SET  ima29='",p_date,"'",      #異動日期    #FUN-A30116
                                 " SET  ima29='",p_date,"'",      #異動日期    #FUN-A30116
                                 " , ima74='",p_date,"'",       #最近出庫日期
                                 " WHERE ima01='",p_item,"'" CLIPPED
 	                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                       PREPARE ima_u6 FROM l_sql
#                      DECLARE ima_up6 CURSOR FOR ima_u6        
                       EXECUTE ima_u6
                            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                               LET g_success='N' 
                               #CALL cl_err('(s_udima1:ckp#6)',SQLCA.sqlcode,1)  #FUN-670091
                               CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#06)",1)  #FUN-670091
                               RETURN 1
                            END IF
					END IF
     {ckp#7}   ELSE
                  #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                  LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                            " SET ima261=ima261-",p_qty, #不可用庫存數量#FUN-A20044
                          # "SET ima29='",p_date,"'",      #異動日期 FUN-A30116 MARK BY COCK
                            " SET ima29='",p_date,"'",      #異動日期
                            " , ima74='",p_date,"'",       #最近出庫日期
                            " WHERE ima01='",p_item,"'" CLIPPED
 	                        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                            PREPARE ima_u7 FROM l_sql
#                           DECLARE ima_up7 CURSOR FOR ima_u7        
                            EXECUTE ima_u7
                            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                               LET g_success='N' 
                               #CALL cl_err('(s_udima1:ckp#7)',SQLCA.sqlcode,1)  #FUN-670091
                               CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#07)",1) #FUN-670091
                               RETURN 1
                            END IF
				 END IF
           WHEN p_type = 1       #入庫
               IF p_img23 MATCHES '[Yy]' THEN        #可用倉
                  IF p_img24 MATCHES '[Yy]' THEN    #mps/mrp 可用
	  {ckp#8}        #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                     LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                               " SET ima26=ima26+",p_qty,   #MPS/MRP可用數量 #FUN-A20044
#                               " , ima262=ima262+",p_qty, #可用庫存數量 #FUN-A20044
#                               "SET  ima29='",p_date,"'",      #異動日期   #FUN-A30116
                               " SET  ima29='",p_date,"'",      #異動日期   #FUN-A30116
                               " , ima73='",p_date,"'",       #最近出庫日期
                               " WHERE ima01='",p_item,"'" CLIPPED
 	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                     PREPARE ima_u8 FROM l_sql
#                    DECLARE ima_up8 CURSOR FOR ima_u8        
                     EXECUTE ima_u8
                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_success='N' 
                        #CALL cl_err('(s_udima1:ckp#8)',SQLCA.sqlcode,1)  #FUN-670091
                         CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#08)",1) #FUN-670091
                        RETURN 1
                     END IF
      {ckp#9}     ELSE 
                     #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                     LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                               " SET ima262=ima262+",p_qty, #可用庫存數量 #FUN-A20044
#                               "SET  ima29='",p_date,"'",      #異動日期     #FUN-A30116
                               " SET  ima29='",p_date,"'",      #異動日期     #FUN-A30116
                               " , ima73='",p_date,"'",       #最近出庫日期
                               " WHERE ima01='",p_item,"'" CLIPPED
 	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                     PREPARE ima_u9 FROM l_sql
#                    DECLARE ima_up9 CURSOR FOR ima_u9        
                     EXECUTE ima_u9
                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_success='N' 
                        #CALL cl_err('(s_udima1:ckp#9)',SQLCA.sqlcode,1)  #FUN-670091
                        CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#09)",1) #FUN-670091
                        RETURN 1
                     END IF
				  END IF
			   ELSE 
    {ckp#10}      #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                  LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                            " SET ima261=ima261+",p_qty, #不可用庫存數量#FUN-A20044
#                            "SET  ima29='",p_date,"'",      #異動日期     #FUN-A30116
                            " SET  ima29='",p_date,"'",      #異動日期     #FUN-A30116
                            " , ima73='",p_date,"'",       #最近出庫日期
                            " WHERE ima01='",p_item,"'" CLIPPED
 	               CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                   PREPARE ima_u10 FROM l_sql
#                  DECLARE ima_up10 CURSOR FOR ima_u10       
                   EXECUTE ima_u10
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                      LET g_success='N' 
                      #CALL cl_err('(s_udima1:ckp#10)',SQLCA.sqlcode,1)  #FUN-670091
                       CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#11)",1) #FUN-670091
                      RETURN 1
                   END IF
			   END IF
            WHEN p_type = -1  #出庫
                 IF p_img23 MATCHES '[Yy]' THEN        #可用倉
                    IF p_img24 MATCHES '[Yy]' THEN    #mps/mrp 可用
   {ckp#11}            #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                       LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                                 " SET ima26=ima26-",p_qty,   #MPS/MRP可用數量 #FUN-A20044
                            #     " , ima262=ima262-",p_qty, #可用庫存數量 #FUN-A20044
					            #"SET  ima40=ima40+",p_qty,   #累計期間使用量 FUN-A30116 MARK BY COCK
		                  " SET ima40=ima40+",p_qty,   #累計期間使用量
					             " , ima41=ima41+",p_qty,   #累計年度使用量
                                 " , ima29='",p_date,"'",      #異動日期
                                 " , ima74='",p_date,"'",       #最近出庫日期
                                 " WHERE ima01='",p_item,"'" CLIPPED
                       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                       PREPARE ima_u11 FROM l_sql
#                      DECLARE ima_up11 CURSOR FOR ima_u11      
                       EXECUTE ima_u11
                       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                          LET g_success='N' 
                          #CALL cl_err('(s_udima1:ckp#11)','9050',1)  #FUN-670091
                           CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#11)",1)  #FUN-670091
                          RETURN 1
                       END IF
				    ELSE
         {ckp#12}      #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                       LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                                 " SET ima262=ima262-",p_qty, #可用庫存數量 #FUN-A20044
					             " SET ima40=ima40+",p_qty,   #累計期間使用量
					             " , ima41=ima41+",p_qty,   #累計年度使用量
                                 " , ima29='",p_date,"'",      #異動日期
                                 " , ima74='",p_date,"'",       #最近出庫日期
                                 " WHERE ima01='",p_item,"'" CLIPPED
 	                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                       PREPARE ima_u12 FROM l_sql
#                      DECLARE ima_up12 CURSOR FOR ima_u12       
                       EXECUTE ima_u12
                       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                          LET g_success='N' 
                          #CALL cl_err('(s_udima1:ckp#12)',SQLCA.sqlcode,1)  #FUN-670091
                          CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#12)",1) #FUN-670091
                          RETURN 1
                       END IF
				    END IF
			     ELSE
      {ckp#13}      #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                    LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                              " SET ima261=ima261-",p_qty, #不可用庫存數量 #FUN-A20044
					         #"SET  ima40=ima40+",p_qty,   #累計期間使用量  #FUN-A30116 MARK
					          " SET  ima40=ima40+",p_qty,   #累計期間使用量
					          " , ima41=ima41+",p_qty,   #累計年度使用量
                              " , ima29='",p_date,"'",      #異動日期
                              " , ima74='",p_date,"'",       #最近出庫日期
                              " WHERE ima01='",p_item,"'" CLIPPED
 	                CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                    PREPARE ima_u13 FROM l_sql
#                   DECLARE ima_up13 CURSOR FOR ima_u13       
                    EXECUTE ima_u13
                    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                       LET g_success='N' 
                       #CALL cl_err('(s_udima1:ckp#13)',SQLCA.sqlcode,1)  #FUN-670091
                       CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#13)",1)  #FUN-670091
                       RETURN 1
                    END IF
				 END IF
           WHEN p_type = 2       #盤點
               IF p_img23 MATCHES '[Yy]' THEN        #可用倉
                  IF p_img24 MATCHES '[Yy]' THEN    #mps/mrp 可用
      {ckp#14}       #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                     LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                               " SET ima262=ima262+",p_qty, #可用庫存數量 #FUN-A20044
                               " SET ima29='",p_date,"'",        #異動日期
                               " , ima30='",p_date,"'",         #最近盤點日期
                               " WHERE ima01='",p_item,"'" CLIPPED
 	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                     PREPARE ima_u14 FROM l_sql
#                    DECLARE ima_up14 CURSOR FOR ima_u14       
                     EXECUTE ima_u14
                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_success='N' 
                        #CALL cl_err('(s_udima1:ckp#14)',SQLCA.sqlcode,1)  #FUN-670091
                         CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#14)",1)  #FUN-670091
                        RETURN 1
                     END IF
       {ckp#15}   ELSE 
                     #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                     LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                               " SET ima262=ima262+",p_qty, #可用庫存數量 #FUN-A20044
                               " SET ima29='",p_date,"'",        #異動日期
                               " , ima30='",p_date,"'",         #最近盤點日期
                               " WHERE ima01='",p_item,"'" CLIPPED
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                     PREPARE ima_u15 FROM l_sql
#                    DECLARE ima_up15 CURSOR FOR ima_u15       
                     EXECUTE ima_u15
                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_success='N' 
                        #CALL cl_err('(s_udima1:ckp#15)',SQLCA.sqlcode,1)   #FUN-670091
                        CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#15)",1)  #FUN-670091
                        RETURN 1
                     END IF
				  END IF
			   ELSE 
        {ckp#16}  #LET l_sql="UPDATE ",p_dbs CLIPPED,"ima_file",
                  LET l_sql="UPDATE ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
#                            " SET ima261=ima261+",p_qty, #不可用庫存數量 #FUN-A20044
                            " SET ima29='",p_date,"'",        #異動日期
                            " , ima30='",p_date,"'",         #最近盤點日期
                            " WHERE ima01='",p_item,"'" CLIPPED
 	              CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                  PREPARE ima_u16 FROM l_sql
#                 DECLARE ima_up16 CURSOR FOR ima_u16       
                  EXECUTE ima_u16
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                     LET g_success='N' 
                     #CALL cl_err('(s_udima1:ckp#16)',SQLCA.sqlcode,1)  #FUN-670091
                      CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","(s_udima1:ckp#16)",1)  #FUN-670091
                     RETURN 1
                  END IF
			   END IF
               OTHERWISE EXIT CASE
            END CASE
 
	 END IF
     IF SQLCA.SQLERRD[3]=0 THEN RETURN 1 END IF
      RETURN 0
END FUNCTION
