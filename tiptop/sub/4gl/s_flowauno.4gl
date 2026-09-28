# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: s_flowauno.4gl
# Descriptions...: 自動賦予多角貿易序號(多角貿易用)
# Date & Author..: 03/08/28 By Kammy
# Usage..........: CALL s_flowauno(p_file,p_flow,p_date) RETURNING l_sta,l_slip99
# Input Parameter: p_file   檔案名稱前三碼
#                  p_flow   流程編號
#                  p_date   單據日期
# RETURN Code....: l_sta    結果碼 0:OK, 1:FAIL
#                  l_slip99 多角序號
# Memo...........: 1.只取來源站的資料 2.多角序號欄位 VARCHAR(15)
# Modify.........: MOD-470528 04/07/27 ching 取號時lock poz_file
# Modify.........: No.FUN-560043 05/06/15 By Smapmin 多角貿易序號放大為17碼
# Modify.........: No.FUN-640248 06/05/26 By Echo 自動執行確認功能
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-720003 07/02/05 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:FUN-A10099 10/01/27 By Carrier 寫成跨db方式
# Modify.........: No:FUN-A10123 10/03/26 By bnlent g_from_dbs --> g_from_dbs_tra 使用實體庫
# Modify.........: No.FUN-A50102 10/06/25 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-A60132 10/07/20 By chenmoyan 將SUBSTR改為GENERO語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
GLOBALS
DEFINE
    g_poz            RECORD LIKE poz_file.*,
    g_year           LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    g_month          LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    g_flowauno_mxno  LIKE oea_file.oea99,         #No.FUN-680147 VARCHAR(17)
    g_message        LIKE ze_file.ze03,           #No.FUN-680147 VARCHAR(70)
    g_forupd_sql     STRING,  #SELECT ... FOR UPDATE SQL
    l_sql            LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(500)
  DEFINE g_from_dbs     LIKE type_file.chr21   #No.FUN-A10099
  DEFINE g_from_dbs_tra LIKE type_file.chr21   #No.FUN-A10099
END GLOBALS
 
FUNCTION s_flowauno(p_file,p_flow,p_date)
DEFINE
    p_file         LIKE zta_file.zta03,        #No.FUN-680147 VARCHAR(3)         #檔名
    p_date         LIKE type_file.dat,          #No.FUN-680147 DATE            #單據日期
    p_flow         LIKE poz_file.poz01,         #No.FUN-680147 VARCHAR(8)         #流程代碼
    p_flow_o       LIKE poz_file.poz01,         #No.FUN-680147 VARCHAR(8)         #流程代碼
    l_slip99       LIKE oea_file.oea99,         #No.FUN-680147 VARCHAR(17)        #多角序號   #FUN-560043
    l_mxno         LIKE poz_file.poz01,         #No.FUN-680147 VARCHAR(8)         #FUN-560043
    l_buf          LIKE type_file.chr50,        #No.FUN-680147 VARCHAR(13)        #FUN-560043 
    l_sta          LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_i            LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_date         LIKE qcs_file.qcs03,         #No.FUN-680147 VARCHAR(6)         #96-09-13
    l_date1        LIKE qcs_file.qcs062         #No.FUN-680147 VARCHAR(4)         #96-09-13   #FUN-560043
 
   #No.FUN-A10099   --Begin
   #多角拋轉來源資料所在的db,集團調撥atmt254時,來源采購單不一定在當前db中
   IF cl_null(g_from_plant) THEN
      LET g_from_plant = g_plant
   END IF
   LET g_plant_new = g_from_plant
   CALL s_getdbs()
   LET g_from_dbs = g_dbs_new
   CALL s_gettrandbs()
   LET g_from_dbs_tra = g_dbs_tra
   #No.FUN-A10099  --End

    #No.8411
    LET p_flow_o=p_flow
    FOR l_i = 1 TO 8
        IF p_flow[l_i,l_i] IS NULL  THEN LET p_flow[l_i,l_i]=' ' END IF
    END FOR
 
    WHENEVER ERROR CONTINUE
 
     #MOD-470528
    ## 為了避免搶號,因此在 select poz_file時便作 lock,待取得單號後再release #
    CALL cl_getmsg('mfg8889',g_lang) RETURNING g_message
 
   #MESSAGE g_message
    CALL cl_msg(g_message)                     #FUN-640248
 
    LET g_forupd_sql = "SELECT * FROM poz_file WHERE poz01   = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE pozauno_cl CURSOR FROM g_forupd_sql
 
     OPEN pozauno_cl USING p_flow_o     # MOD-510143
    IF SQLCA.sqlcode = "-263" THEN
#NO.FNN-720003-------begin
       IF g_bgerr THEN
          CALL s_errmsg('poz01','','poz01:read poz:',SQLCA.sqlcode,1)
       ELSE 
          CALL cl_err('poz01:read poz:',SQLCA.sqlcode,1)
       END IF
#NO.FUN-720003-------end
        CLOSE pozauno_cl 
        RETURN -1,''
    END IF
    FETCH pozauno_cl INTO g_poz.*      # 鎖住將的資料
    IF SQLCA.sqlcode = "-263" THEN
#NO.FNN-720003-------begin                                                                                                          
       IF g_bgerr THEN                                                                                                              
          CALL s_errmsg('poz01','','poz01:read poz:',SQLCA.sqlcode,1)                                                               
       ELSE         
          CALL cl_err('poz01:read poz:',SQLCA.sqlcode,1)
       END IF                                                                                                                       
#NO.FUN-720003-------end 
        CLOSE pozauno_cl 
        RETURN -1,''
    END IF
{
    SELECT * INTO g_poz.* FROM poz_file WHERE poz01 = p_flow_o
    IF STATUS THEN
       CALL cl_err('','axm-318',1) 
       RETURN 1,''
    END IF
}
   #--
 
    SELECT azn02,azn04 INTO g_year,g_month FROM azn_file WHERE azn01=p_date
    IF STATUS THEN 
       LET g_year =YEAR(p_date)
       LET g_month=MONTH(p_date)
    END IF
    #No.FUN-A10099  --Begin
    IF g_poz.poz11 = '1' THEN    #依流水號
       CASE p_file
          WHEN 'oea'             #訂單
             SELECT MAX(oea99) INTO g_flowauno_mxno FROM oea_file  
              WHERE oea99[1,8] = p_flow
             #LET l_sql = "SELECT MAX(oea99) FROM ",g_from_dbs_tra CLIPPED,"oea_file", #No.FUN-A10123
             LET l_sql = "SELECT MAX(oea99) FROM ",cl_get_target_table(g_from_plant,'oea_file'), #FUN-A50102
#                        " WHERE SUBSTR(oea99,1,8) = '",p_flow,"'" #TQC-A60132
                         " WHERE oea99[1,8] = '",p_flow,"'"        #TQC-A60132
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql #FUN-A50102            
             PREPARE oea_p1 FROM l_sql
             EXECUTE oea_p1 INTO g_flowauno_mxno
          WHEN 'oga'             #出貨單
             #SELECT MAX(oga99) INTO g_flowauno_mxno FROM oga_file
             # WHERE oga99[1,8] = p_flow
             #LET l_sql = "SELECT MAX(oga99) FROM ",g_from_dbs_tra CLIPPED,"oga_file", #No.FUN-A10123
             LET l_sql = "SELECT MAX(oga99) FROM ",cl_get_target_table(g_from_plant,'oga_file'), #FUN-A50102
#                        " WHERE SUBSTR(oga99,1,8) = '",p_flow,"'" #TQC-A60132
                         " WHERE oga99[1,8] = '",p_flow,"'"        #TQC-A60132
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql #FUN-A50102              
             PREPARE oga_p1 FROM l_sql
             EXECUTE oga_p1 INTO g_flowauno_mxno
          WHEN 'pmm'             #採購單
             #SELECT MAX(pmm99) INTO g_flowauno_mxno FROM pmm_file
             # WHERE pmm99[1,8] = p_flow
             #LET l_sql = "SELECT MAX(pmm99) FROM ",g_from_dbs_tra CLIPPED,"pmm_file", #No.FUN-A10123\
             LET l_sql = "SELECT MAX(pmm99) FROM ",cl_get_target_table(g_from_plant,'pmm_file'), #FUN-A50102 
#                        " WHERE SUBSTR(pmm99,1,8) = '",p_flow,"'" #TQC-A60132
                         " WHERE pmm99[1,8] = '",p_flow,"'"        #TQC-A60132
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql #FUN-A50102              
             PREPARE pmm_p1 FROM l_sql
             EXECUTE pmm_p1 INTO g_flowauno_mxno
          WHEN 'rvu'             #入庫單
             #SELECT MAX(rvu99) INTO g_flowauno_mxno FROM rvu_file
             # WHERE rvu99[1,8] = p_flow
             #LET l_sql = "SELECT MAX(rvu99) FROM ",g_from_dbs_tra CLIPPED,"rvu_file", #No.FUN-A10123
             LET l_sql = "SELECT MAX(rvu99) FROM ",cl_get_target_table(g_from_plant,'rvu_file'), #FUN-A50102
#                        " WHERE SUBSTR(rvu99,1,8) = '",p_flow,"'" #TQC-A60132
                         " WHERE rvu99[1,8] = '",p_flow,"'"        #TQC-A60132
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql #FUN-A50102             
             PREPARE rvu_p1 FROM l_sql
             EXECUTE rvu_p1 INTO g_flowauno_mxno
          WHEN 'oha'             #銷退單
             #SELECT MAX(oha99) INTO g_flowauno_mxno FROM oha_file
             # WHERE oha99[1,8] = p_flow
             #LET l_sql = "SELECT MAX(oha99) FROM ",g_from_dbs_tra CLIPPED,"oha_file", #No.FUN-A10123
             LET l_sql = "SELECT MAX(oha99) FROM ",cl_get_target_table(g_from_plant,'oha_file'), #FUN-A50102 
#                        " WHERE SUBSTR(oha99,1,8) = '",p_flow,"'" #TQC-A60132
                         " WHERE oha99[1,8] = '",p_flow,"'"        #TQC-A60132
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql #FUN-A50102             
             PREPARE oha_p1 FROM l_sql
             EXECUTE oha_p1 INTO g_flowauno_mxno
          OTHERWISE EXIT CASE
        END CASE
     ELSE             #依年度期別
        #----- modi by kitty 96-09-13 ---------------
        LET l_date = g_year USING '&&&&',g_month USING '&&'
#FUN-560043
        #LET l_date1[1,1]=l_date[4,4]
        LET l_date1[1,2]=l_date[3,4]  
        {
              CASE WHEN g_month = 10 LET l_date1[2,2]='A'
                   WHEN g_month = 11 LET l_date1[2,2]='B'
                   WHEN g_month = 12 LET l_date1[2,2]='C'
                   OTHERWISE         LET l_date1[2,2]=l_date[6,6]
              END CASE
        } 
        LET l_date1[3,4]=l_date[5,6]
#END FUN-560043
        #-------------------------------------------
        LET l_buf=p_flow,'-',l_date1
        CASE p_file 
          WHEN 'oea'             #訂單
            #SELECT MAX(oea99) INTO g_flowauno_mxno FROM oea_file
            # #WHERE oea99[1,11] = l_buf   #FUN-560043
            # WHERE oea99[1,13] = l_buf   #FUN-560043
             #LET l_sql = "SELECT MAX(oea99) FROM ",g_from_dbs_tra CLIPPED,"oea_file", #No.FUN-A10123
             LET l_sql = "SELECT MAX(oea99) FROM ",cl_get_target_table(g_from_plant,'oea_file'), #FUN-A50102
#                        " WHERE SUBSTR(oea99,1,13) = '",l_buf,"'" #TQC-A60132
                         " WHERE oea99[1,13] = '",l_buf,"'"        #TQC-A60132
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql #FUN-A50102             
             PREPARE oea_p11 FROM l_sql
             EXECUTE oea_p11 INTO g_flowauno_mxno
          WHEN 'oga'             #出貨單
            #SELECT MAX(oga99) INTO g_flowauno_mxno FROM oga_file
            # #WHERE oga99[1,11] = l_buf   #FUN-560043
            # WHERE oga99[1,13] = l_buf   #FUN-560043
             #LET l_sql = "SELECT MAX(oga99) FROM ",g_from_dbs_tra CLIPPED,"oga_file", #No.FUN-A10123
             LET l_sql = "SELECT MAX(oga99) FROM ",cl_get_target_table(g_from_plant,'oga_file'), #FUN-A50102
#                        " WHERE SUBSTR(oga99,1,13) = '",l_buf,"'" #TQC-A60132
                         " WHERE oga99[1,13] = '",l_buf,"'"        #TQC-A60132
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql #FUN-A50102             
             PREPARE oga_p11 FROM l_sql
             EXECUTE oga_p11 INTO g_flowauno_mxno
          WHEN 'pmm'             #採購單
            #SELECT MAX(pmm99) INTO g_flowauno_mxno FROM pmm_file
            # #WHERE pmm99[1,11] = l_buf   #FUN-560043
            # WHERE pmm99[1,13] = l_buf   #FUN-560043
             #LET l_sql = "SELECT MAX(pmm99) FROM ",g_from_dbs_tra CLIPPED,"pmm_file", #No.FUN-A10123
             LET l_sql = "SELECT MAX(pmm99) FROM ",cl_get_target_table(g_from_plant,'pmm_file'), #FUN-A50102
#                        " WHERE SUBSTR(pmm99,1,13) = '",l_buf,"'" #TQC-A60132
                         " WHERE pmm99[1,13] = '",l_buf,"'"        #TQC-A60132
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql #FUN-A50102             
             PREPARE pmm_p11 FROM l_sql
             EXECUTE pmm_p11 INTO g_flowauno_mxno
          WHEN 'rvu'             #入庫單
            #SELECT MAX(rvu99) INTO g_flowauno_mxno FROM rvu_file
            # #WHERE rvu99[1,11] = l_buf   #FUN-560043
            # WHERE rvu99[1,13] = l_buf   #FUN-560043
             #LET l_sql = "SELECT MAX(rvu99) FROM ",g_from_dbs_tra CLIPPED,"rvu_file", #No.FUN-A10123
             LET l_sql = "SELECT MAX(rvu99) FROM ",cl_get_target_table(g_from_plant,'rvu_file'), #FUN-A50102
#                        " WHERE SUBSTR(rvu99,1,13) = '",l_buf,"'" #TQC-A60132
                         " WHERE rvu99[1,13] = '",l_buf,"'"        #TQC-A60132
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql #FUN-A50102             
             PREPARE rvu_p11 FROM l_sql
             EXECUTE rvu_p11 INTO g_flowauno_mxno
          WHEN 'oha'             #銷退單
            #SELECT MAX(oha99) INTO g_flowauno_mxno FROM oha_file
            # #WHERE oha99[1,11] = l_buf   #FUN-560043
            # WHERE oha99[1,13] = l_buf   #FUN-560043
             #LET l_sql = "SELECT MAX(oha99) FROM ",g_from_dbs_tra CLIPPED,"oha_file", #No.FUN-A10123
             LET l_sql = "SELECT MAX(oha99) FROM ",cl_get_target_table(g_from_plant,'oha_file'), #FUN-A50102
#                        " WHERE SUBSTR(oha99,1,13) = '",l_buf,"'" #TQC-A60132
                         " WHERE oha99[1,13] = '",l_buf,"'"        #TQC-A60132
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql #FUN-A50102             
             PREPARE oha_p11 FROM l_sql
             EXECUTE oha_p11 INTO g_flowauno_mxno
          OTHERWISE EXIT CASE
        END CASE
     END IF   
     #LET l_mxno = g_flowauno_mxno[10,15]    #FUN-560043
     LET l_mxno = g_flowauno_mxno[10,17]    #FUN-560043
     LET l_slip99[1,8] = p_flow
     #IF cl_null(l_slip99[10,15]) THEN   #FUN-560043
     IF cl_null(l_slip99[10,17]) THEN   #FUN-560043
       IF g_poz.poz11 = '1' THEN                      #依流水號
          IF cl_null(l_mxno) THEN                     #最大編號未曾指定
             #LET l_mxno = '000000'   #FUN-560043
             LET l_mxno = '00000000'   #FUN-560043
          END IF
          #LET l_slip99[10,15]=(l_mxno+1) USING '&&&&&&'
          LET l_slip99[10,17]=(l_mxno+1) USING '&&&&&&&&'
        ELSE                                          #依年月
           IF cl_null(l_mxno) THEN                    #最大編號未曾指定
              LET l_buf = g_year USING '&&&&',g_month USING '&&'
#FUN-560043
              #LET l_mxno[1,1]=l_buf[4,4]
              LET l_mxno[1,2]=l_buf[3,4]
              LET l_mxno[3,4]=l_buf[5,6]
              {
              CASE WHEN g_month = 10 LET l_mxno[2,2]='A'
                   WHEN g_month = 11 LET l_mxno[2,2]='B'
                   WHEN g_month = 12 LET l_mxno[2,2]='C'
                   OTHERWISE         LET l_mxno[2,2]=l_buf[6,6]
              END CASE
              }
             #LET l_mxno[3,6]='0000'
             LET l_mxno[5,8]='0000'
#END FUN-560043
           END IF
           #LET l_slip99[10,15]=l_mxno[1,2],(l_mxno[3,6]+1) USING '&&&&'
           LET l_slip99[10,17]=l_mxno[1,4],(l_mxno[5,8]+1) USING '&&&&'
       END IF
    END IF
    #No.FUN-A10099  --End
    LET l_slip99[9,9]='-'
    RETURN 0,l_slip99
END FUNCTION
