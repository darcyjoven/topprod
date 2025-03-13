# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: s_umfchkm.4gl
# Descriptions...: 兩單位間之轉換率計算與檢查
# Date & Author..: 98/12/09 By  Linda
# Usage..........: CALL s_umfchkm(p_item,p_1,p_2,p_dbs) RETURNING l_flag,l_fac
# Input Parameter: p_item  料件	 
#                  p_1     來源單位
#                  p_2     目的單位
#                  p_dbs   資料庫名稱
# Return code....: l_flag  是否有此單位轉換
#                    0   OK
#                    1   ERROR
#                  l_fac   轉換率
# Memo...........: copy自s_umfchk.4gl, 改成多工廠
# Modify.........: No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-720003 07/02/05 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980020 09/09/11 By douzh GP集團架構修改,sub相關參數
# Modify.........: No:MOD-9B0132 09/11/20 By 過濾 MISC 處理
# Modify.........: No.FUN-A50102 10/06/30 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.FUN-B70076 11/07/21 By Mandy l_sql DEFINE 錯誤
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_umfchkm(p_item,p_1,p_2,p_dbs)       #FUN-980020 mark
FUNCTION s_umfchkm(p_item,p_1,p_2,p_plant)      #FUN-980020
    DEFINE p_item     LIKE smd_file.smd01,      #No.MOD-490217
           p_1        LIKE smd_file.smd02, 	#No.FUN-680147 VARCHAR(04)
           p_2        LIKE smd_file.smd03, 	#No.FUN-680147 VARCHAR(04)
           p_dbs      LIKE type_file.chr21,     #資料庫名稱  	#No.FUN-680147 VARCHAR(21)
           l_flag     LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
           l_factor   LIKE ima_file.ima31_fac,  #No.FUN-680147 DECIMAL(16,8)
          #l_sql      LIKE type_file.chr1000,	#No.FUN-680147 VARCHAR(1000) #FUN-B70076 mark
           l_sql      STRING,                   #                            #FUN-B70076 add
           l_su       LIKE ima_file.ima31_fac,  #來源單位兌換數量 	#No.FUN-680147
           l_tu       LIKE ima_file.ima31_fac   #目的單位兌換數量 	#No.FUN-680147
    DEFINE p_plant    LIKE type_file.chr10      #FUN-980020

#FUN-A50102--mark--str--    
#FUN-980020--begin    
    #IF cl_null(p_plant) THEN
    #   LET p_dbs = NULL
    #ELSE
    #   LET g_plant_new = p_plant
    #   CALL s_getdbs()
    #   LET p_dbs = g_dbs_new
    #END IF
#FUN-980020--end 
#FUN-A50102--mark--end--   
 
   #IF p_1=p_2 THEN RETURN 0,1.0 END IF                           #MOD-9B0132 mark
    IF p_1=p_2 OR p_item[1,4]='MISC' THEN RETURN 0,1.0 END IF     #MOD-9B0132

    LET l_flag  = 0
    LET l_sql = "SELECT smd04,smd06 ",
                #" FROM ",p_dbs CLIPPED,"smd_file " ,
                " FROM ",cl_get_target_table(p_plant,'smd_file'), #FUN-A50102
                " WHERE  smd01='",p_item,"' AND smd02='",p_1,"' ",
                "   AND  smd03='",p_2,"' "       
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE smd_pr2 FROM l_sql 
    IF STATUS THEN 
       #CALL cl_err('smd_pr2',STATUS,1)   #FUN-670091
#       CALL cl_err3("sel","smd_file",p_item,"",STATUS,"","smd_pr2",1)  #FUN-670091
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','smd_pr2',STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('smd_pr2',STATUS,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end         
    END IF
    DECLARE smd_cu2 CURSOR FOR smd_pr2
    OPEN smd_cu2
    FETCH smd_cu2 INTO  l_su,l_tu       #check 料件單位換算
    IF STATUS OR SQLCA.SQLCODE THEN 
        LET l_sql = "SELECT smd06,smd04 ",
                    #" FROM ",p_dbs CLIPPED,"smd_file " ,
                    " FROM ",cl_get_target_table(p_plant,'smd_file'), #FUN-A50102
                    " WHERE  smd01='",p_item,"' AND smd02='",p_2,"' ",
                    "   AND  smd03='",p_1,"' "         
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE smd_pr3 FROM l_sql 
        IF STATUS THEN 
           #CALL cl_err('smd_pr3',STATUS,1) 
#          CALL cl_err3("sel","smd_file",p_item,"",STATUS,"","smd_pr3",1)  #FUN-670091
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','smd_pr3',STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('smd_pr3',STATUS,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
        END IF
        DECLARE smd_cu3 CURSOR FOR smd_pr3
        OPEN smd_cu3
        FETCH smd_cu3 INTO  l_su,l_tu       #check 料件單位換算
        IF STATUS OR SQLCA.SQLCODE THEN 
            LET l_sql = "SELECT smc03,smc04 ",
                        #" FROM ",p_dbs CLIPPED,"smc_file " ,
                        " FROM ",cl_get_target_table(p_plant,'smc_file'), #FUN-A50102
                        " WHERE  smc01='",p_1,"' ",
                        "   AND  smc02='",p_2,"' ",
                        "   AND  smcacti='Y' "   #NO:4757          
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
            PREPARE smc_pr2 FROM l_sql 
            IF STATUS THEN 
               #CALL cl_err('smc_pr2',STATUS,1)  #FUN-670091
#              CALL cl_err3("sel","smc_file",p_1,"",STATUS,"","smd_pr2",1)  #FUN-670091
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','smc_pr2',STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('smc_pr2',STATUS,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
            END IF
            DECLARE smc_cu2 CURSOR FOR smc_pr2
            OPEN smc_cu2
            FETCH smc_cu2 INTO  l_su,l_tu       #check 料件單位換算
            IF STATUS OR SQLCA.SQLCODE THEN 
               LET l_flag=1 
            END IF
            CLOSE smc_cu2
        END IF
        CLOSE smd_cu3
     END IF
     CLOSE smd_cu2
     IF l_flag = 0 
        THEN IF l_su = 0 OR l_su IS NULL
                THEN LET  l_factor = 0
                ELSE LET  l_factor = l_tu / l_su     #轉換率
             END IF
     END IF
   RETURN l_flag,l_factor
END FUNCTION
