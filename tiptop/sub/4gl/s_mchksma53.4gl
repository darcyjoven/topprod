# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_mchksma53.4gl
# Descriptions...: 多角貿易檢查各工廠成本關帳日(sma53)
# Date & Author..: 03/08/31 BY Kammy
# Usage..........: CALL s_mchksma53(p_flow,p_date) RETURNING l_rs
# Input Parameter: p_flow    流程代號
#                  p_date    單據日期
# Return code....: l_status  0:OK 1:NG 
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-720003 07/02/04 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-860236 08/06/20 By claire 需由第0站開始check
# Modify.........: No.MOD-970170 09/07/20 By Dido 增加跨主機語法置換函數
# Modify.........: No.FUN-980059 09/09/10 By arman  將傳入的DB變數改成plant變數
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_mchksma53(p_flow,p_date)
DEFINE  p_flow        LIKE oea_file.oea904 ,
        p_date        LIKE type_file.dat              #No.FUN-680147 DATE
DEFINE  l_last        LIKE poy_file.poy02
DEFINE  l_last_plant  LIKE poy_file.poy04
DEFINE  l_plant       LIKE poy_file.poy04
DEFINE  l_db          LIKE azp_file.azp03,
        l_poz         RECORD LIKE poz_file.* ,        # 流程(單頭)
        l_poy         RECORD LIKE poy_file.* ,        # 流程(單身)
        l_status,i    LIKE type_file.num5             #No.FUN-680147 SMALLINT
 
        LET l_status = 0
        SELECT * INTO l_poz.* FROM poz_file WHERE poz01 = p_flow
        CALL s_tri_last(p_flow) RETURNING l_last,l_last_plant    #No.8640
       #FOR i = 1 TO l_last   #MOD-860236 mark
        FOR i = 0 TO l_last   #MOD-860236
            SELECT poy04 INTO l_plant FROM poy_file 
             WHERE poy01 = p_flow AND poy02 = i
            IF STATUS OR STATUS = 100 THEN
#              CALL cl_err('','axm-318',1) 
#No.FUN-720003--begin
            IF g_bgerr THEN
               CALL s_errmsg('','','','axm-318',1)
            ELSE
               CALL cl_err('','axm-318',1)
            END IF
#No.FUN-720003--end          
               LET l_status = 1 
               EXIT FOR
            END IF
            SELECT  azp03 INTO l_db FROM azp_file WHERE azp01 = l_plant
            LET l_db=s_dbstring(l_db)
#           IF s_mchksma53_chk_sma53(l_db,p_date) THEN LET l_status= 1 END IF     #No.FUN-980059 mark
            IF s_mchksma53_chk_sma53(l_plant,p_date) THEN LET l_status= 1 END IF  #No.FUN-980059
        END FOR
        RETURN l_status
END FUNCTION 
 
#FUNCTION s_mchksma53_chk_sma53(l_db,p_date)      #檢查關帳日    #No.FUN-980059 mark
FUNCTION s_mchksma53_chk_sma53(l_plant,p_date)    #檢查關帳日    #No.FUN-980059
DEFINE  p_date   LIKE type_file.dat              #No.FUN-680147 DATE
DEFINE  l_db     LIKE azp_file.azp03
DEFINE  l_plant     LIKE azp_file.azp01          #No.FUN-980059
DEFINE  l_sma53  LIKE type_file.dat,             #No.FUN-680147 DATE
        l_sql    LIKE type_file.chr1000          #No.FUN-680147 VARCHAR(200)
      ##NO.FUN-980059 GP5.2 add begin
       IF cl_null(l_plant) THEN
        LET l_db = NULL
       ELSE
        LET g_plant_new = l_plant
        CALL s_getdbs()
        LET l_db = g_dbs_new
       END IF
     ##NO.FUN-980059 GP5.2 add end
 
     #LET l_sql = "SELECT sma53 FROM ",l_db CLIPPED ,"sma_file  ",
     LET l_sql = "SELECT sma53 FROM ",cl_get_target_table(l_plant,'sma_file'), #FUN-A50102
                 " WHERE sma00 = '0'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#MOD-970170
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
     PREPARE sma53_prepare FROM l_sql
     DECLARE sma53_cs CURSOR FOR sma53_prepare
     OPEN  sma53_cs
     FETCH sma53_cs INTO l_sma53 
     CLOSE sma53_cs
 
     IF  l_sma53 >= p_date THEN  #已經小於關帳日,
#        CALL cl_err(l_db,'axr-164',1)  #異動日期不可小於關帳日期!
#No.FUN-720003--begin                                                                                                               
            IF g_bgerr THEN                                                                                                         
               CALL s_errmsg('','',l_db,'axr-164',1)                                                                                  
            ELSE                                                                                                                    
               CALL cl_err(l_db,'axr-164',1)                                                                                          
            END IF                                                                                                                  
#No.FUN-720003--end                        
         RETURN 1
     END IF
     RETURN 0
END FUNCTION
