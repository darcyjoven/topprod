# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# DESCRIPTIONs...:『TOPICS/MFG』系統關閉訊息產生
#                  Put shutdown message   
# Input PARAMETER: p_code  :程式編號
#                  p_rev   :模擬版本
# RTURN Code.....: p_st    :成本否(Y/N)
# Date & Author..: 93/08/27 By Apple
# Modify.........: 04/07/20 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_psdm(p_code,p_rev)
   DEFINE  p_code          LIKE zaa_file.zaa01,          # Prog. Version..: '5.30.06-13.03.12(08)    #程式編號
           p_rev           LIKE aba_file.aba18,          # Prog. Version..: '5.30.06-13.03.12(02)    #模擬版本
           p_st            LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)    #成功否
           l_rem1,l_rem2,l_rem3  LIKE type_file.chr1000, #No.FUN-680147 VARCHAR(30)
           l_tty           LIKE gat_file.gat01,          #No.FUN-680147 VARCHAR(15)
           l_date          LIKE type_file.chr20,         #No.FUN-680147 VARCHAR(08)
           l_time          LIKE type_file.chr8           #No.FUN-680147 VARCHAR(8)
         
   WHENEVER ERROR CALL cl_err_msg_log
    LET p_st ='Y'
    UPDATE sma_file SET sma01 ='N' WHERE 1=1
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 
    THEN #CALL cl_err(sqlca.sqlcode,'mfg9230',1)  #FUN-670091
          CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","mfg9230",1)  #FUN-670091
         LET p_st ='N'
    ELSE 
        CASE 
          WHEN p_code = 'amrp100'   
               LET l_rem1 = '『再生式－物料需求計劃』作業'
          WHEN p_code = 'amrp119'   
               LET l_rem1 = '『淨增式－物料需求計劃』作業'
          WHEN p_code = 'amrp200'
               LET l_rem1 = '『物料需求計劃』模擬執行作業'
          WHEN p_code = 'amsp700'
               LET l_rem1 = '主排程執行計劃作業'
          WHEN p_code = 'acsp101'
               LET l_rem1 = '料件預設成本逆算作業－單一料件'
          WHEN p_code = 'acsp201'
               LET l_rem1 = '料件預設成本逆算作業－全部料件'
          WHEN p_code = 'acsp100'
               LET l_rem1 = '料件標準成本逆算作業－單一料件'
          WHEN p_code = 'acsp200'
               LET l_rem1 = '料件標準成本逆算作業－全部料件'
          OTHERWISE EXIT CASE
        END CASE
        IF p_rev IS NOT NULL OR p_rev != ' '
        THEN LET l_rem2 = '模擬版本',p_rev clipped,' 執行選擇 - 系統關閉'
        END IF
        LET l_date = g_today
        LET l_time = TIME
        LET l_rem3 = l_date,' ',l_time clipped
	    CALL fgl_getenv('LOGTTY') RETURNING l_tty
         INSERT INTO smi_file(smi01,smi02,smi03,smi04,smi05,smi06,smi07,smi08,smiplant,smilegal) #No.MOD-470041 #FUN-980012 add
                      VALUES(g_user,p_code,g_today,
                             l_time,l_tty, l_rem1, 
                             l_rem2,l_rem3,g_plant,g_legal) #FUN-980012 add
        IF SQLCA.sqlcode THEN 
           UPDATE sma_file SET sma01='Y' 
           #CALL cl_err(sqlca.sqlcode,'mfg9229',1)  #FUN-670091
            CALL cl_err3("ins","smi_file","","",SQLCA.sqlcode,"","mfg9229",1)  #FUN-670091
           LET p_st ='N'
        END IF
    END IF
    RETURN p_st
END FUNCTION
